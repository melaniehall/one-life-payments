OneLifePayments::Application.routes.draw do

  devise_for :users

  resources :contributions
  resources :donors

  root to: "home#index"
  match '/thank_you' => 'contributions#thank_you', :via => :get
  match '/card_errors' => 'contributions#card_errors', :via => :get
  match '/about' => 'home#about', :via => :get
  match '/our_work' => 'home#our_work', :via => :get
  match '/communities' => 'home#communities', :via => :get
    match '/communities/khalpar' => 'home#communities/khalpar', :via => :get
    match '/communities/gaborda' => 'home#communities/gaborda', :via => :get
    match '/communities/kantapakur' => 'home#communities/kantapakur', :via => :get
    match '/communities/nalpur' => 'home#communities/nalpur', :via => :get
    match '/communities/basirhat' => 'home#communities/basirhat', :via => :get
  match '/contact' => 'home#contact', :via => :get
  match '/giving-support' => 'home#giving-support', :via => :get

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
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
