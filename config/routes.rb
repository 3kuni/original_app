Rails.application.routes.draw do
  get 'studysessions/stats'

  get 'textbooks/new'
  get 'users/show'

  root 'static_pages#home',via:[:get,:post]
  devise_for :users, :controllers => {
    :sessions      => "users/sessions",
    :registrations => "users/registrations",
    :passwords     => "users/passwords",
    :omniauth_callbacks => "users/omniauth_callbacks" 
  }
  resources:studysessions
  resources:posts
  #match 'users/:id/' ,to:'users#show',via: [:get]
  #match 'users/' ,to:'users#index',via: [:get]
  resources :users do
    member do
      get :following, :followers
    end
  end  
  match '/studysessions/amazon' ,to:'studysessions#amazon_index',via: [:post]
  match 'studysessions/stop/:id/:user/:time' , to: 'studysessions#stop' ,via: [:patch,:get]
  match 'studysessions/studying/:id/:room' ,to:'studysessions#index',via: [:get]
  match '/ssession' , to:'studysessions#first_step', via: [:get]
  match '/studysessions/new/:id/:room' , to:'studysessions#new', via: [:get,:post]
  get  "/studysessions/new/:id" => redirect("/ssession")
  resources :relationships, only: [:create, :destroy]
  match '/studysessions/like/:studysession_id/' , to:'studysessions#like', via: [:get]
  match '/studysessions/edit/:studysession_id/' , to:'studysessions#edit',via:[:get]
  #match '/studysessions/stats' , to:'studysessions#stats', via: [:get]
  match '/studysessions/start/:id' , to:'studysessions#start', via: [:post]
  match '/studysessions/done/:id' , to: 'studysessions#done', via:[:post]
  
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

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
end
