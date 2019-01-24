Rails.application.routes.draw do
  devise_for :users
  resources :cloud_files, :regions
  resource :overview

  get 'settings' => redirect("settings/account#show")
  namespace :settings do
    resource :account
    resources :buckets
  end

  namespace :api, :defaults => { :format => 'json' }  do
    namespace :v1 do
      resources :cloud_files do 
        member do
          post :authorize
        end
      end
    end
  end

  resource :external do
    collection do
      :homepage
    end
  end

  namespace :admin do
    resources :regions
  end

  # trick pulled from http://stackoverflow.com/questions/3791096/devise-logged-in-root-route-rails-3
  # there might be a better way of doing this...
  root'externals#homepage'#, :constraints => lambda {|r| r.env["warden"].authenticate? }

end
