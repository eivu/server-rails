Rails.application.routes.draw do
  devise_for :users
  resources :cloud_files
  resource :overview

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # trick pulled from http://stackoverflow.com/questions/3791096/devise-logged-in-root-route-rails-3
  # there might be a better way of doing this...
  root'overview#show'#, :constraints => lambda {|r| r.env["warden"].authenticate? }
  # root'homes#show'

end
