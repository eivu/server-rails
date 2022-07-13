# frozen_string_literal: true
require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'

  ##### GraphQL #####
  get  '/graphql',    to: 'graphql#inform', format: 'json'
  post '/graphql',    to: 'graphql#execute', format: 'json'
  post '/graphql',    to: 'graphql#execute'
  post '/statistics', to: 'graphql#statistics', format: 'json'

  devise_for :users
  devise_scope :user do
    get '/users/sign_out', to: 'devise/sessions#destroy'
  end


  resources :cloud_files, :regions, :folders, :metadata
  resource :overview

  get 'settings' => redirect('settings/account#show')
  namespace :settings do
    resource :account
    resources :buckets
  end

  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do
      get :info, to: 'v1#info'
      resources :folders
      resources :cloud_files, only: :show, param: :md5 do
        member do
          post :reserve
          post :transfer
          post :complete
          post :authorize
          post :update_metadata
        end
      end
    end
  end

  resource :external do
    collection do
      :homepage
    end
  end

  # trick pulled from http://stackoverflow.com/questions/3791096/devise-logged-in-root-route-rails-3
  # there might be a better way of doing this...
  root 'externals#homepage' # , :constraints => lambda {|r| r.env['warden'].authenticate? }
end
