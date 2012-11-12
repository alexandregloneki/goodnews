GoodNotice::Application.routes.draw do
  
  resources :notifications

  mount MongodbLogger::Server.new, :at => "/mongodb"  
  
  #resources :payments

  mount Ckeditor::Engine => '/ckeditor'

  devise_for :admins
  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'
  devise_for :users, :skip => [:workflows_rules]  
  
  resources :operators

  resources :rules

  match 'sms/history/', :controller=>"sms", :action=>"history"
  match 'sms/export/', :controller=>"sms", :action=>"export"
  match 'sms/export/', :controller=>"sms", :action=>"export"
  match 'sms/export_file/', :controller=>"sms", :action=>"export_file"
  resources :sms

  resources :statuses

  match 'accounts/edit/', :controller=>"accounts", :action=>"edit"
  match 'accounts/key_generate/', :controller=>"accounts", :action=>"key_generate"
  resources :accounts
  
  match 'workflows/history/', :controller=>"workflows", :action=>"history"
  match 'workflows/export/', :controller=>"workflows", :action=>"export"
  match 'workflows/export/', :controller=>"workflows", :action=>"export"
  match 'workflows/send_out/:id', :controller=>"workflows", :action=>"send_out"
  match 'workflows/export_file/', :controller=>"workflows", :action=>"export_file"
  match 'workflows/save_comunication/', :controller=>"workflows", :action=>"save_comunication"
  resources :workflows

  match 'emails/load_copy', :controller=>"emails", :action=>"load_copy"
  match 'emails/history/', :controller=>"emails", :action=>"history"
  match 'emails/export/', :controller=>"emails", :action=>"export"
  match 'emails/export_file/', :controller=>"emails", :action=>"export_file"
  resources :home
  match 'home/index', :controller=>"home", :action=>"index"
  resources :emails
  
  match 'payments/checkout/', :controller=>"payments", :action=>"checkout"
  resources :payments
  
  match 'return_payments/confirm/', :controller=>"return_payments", :action=>"confirm"
  
  namespace :api do
    match 'send_datas/send_data/', :controller=>"send_datas", :action=>"send_data" 
    match 'workflows_rules/send_data/', :controller=>"workflows_rules", :action=>"send_data"
    resources :workflows_rules
    
  end
   
  match "api_testes/(.:format)" => "api_testes#index"  
  
  
  
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
   root :to => 'home#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
   match ':controller(/:action(/:id))(.:format)'
end
