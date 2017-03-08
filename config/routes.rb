Rails.application.routes.draw do
  get 'correct_answers/show'

  get 'correct_answers/index'

  get 'correct_answers/edit'

  # TODO: wordとwordsのルーティングが自動で生成されているので、必要なものとそうでないものを振り分けて削除。
  get 'words/show'
  get 'words/new'
  get 'words/create'
  get 'words/update'
  get 'words/index'

  get 'word/index'
  get 'word/create'
  get 'word/edit'
  get 'word/update'
  get 'word/update'
  get 'word/show'

  get 'studysessions/stats'

  get 'textbooks/new'
  get 'users/show'

  root 'static_pages#home'
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
  match 'studysessions/stop/:id/:user/:time/:room' , to: 'studysessions#stop' ,via: [:patch,:get]
  match 'studysessions/studying/:id/:room' ,to:'studysessions#index',via: [:get]
  match '/ssession' , to:'studysessions#first_step', via: [:get]
  match '/studysessions/new/:id/:room' , to:'studysessions#new', via: [:get,:post]
  get  "/studysessions/new/:id" => redirect("/ssession")
  resources :relationships, only: [:create, :destroy]
  match '/studysessions/like/:studysession_id/' , to:'studysessions#like', via:[:get]
  match '/studysessions/edit/:studysession_id/' , to:'studysessions#edit',via:[:get]
  #match '/studysessions/stats' , to:'studysessions#stats', via: [:get]

  resources :words
  match '/word/batch', to:'words#batch', via: [:get]
  match '/word/tsv', to: 'words#tsv', via: [:post]
  # アプリから呼び出すapiはwordcard_apiコントローラ、単語一括登録などはwordコントローラ
  match '/wc/api/v0/regi', to: 'wordcard_api#register', via: [:post]
  match '/wc/api/v0/signin', to: 'wordcard_api#signin', via: [:post]
  match '/wc/api/v0/load', to: 'wordcard_api#load', via:[:post]
  match '/wc/api/v0/log', to: 'wordcard_api#remotelog', via:[:post]

  # Rails側で操作するAPI系
  match '/kakomon/api/v0/showYear', to: 'kakomon_api#showYear', via:[:get]
  match '/kakomon/api/v0/getCorrectAnswer', to: 'kakomon_api#getCorrectAnswer', via:[:post]
  match '/kakomon/api/v0/sendUserAnswer', to: 'kakomon_api#userAnswer', via:[:post]
  match '/kakomon/api/v0/sendUserScore', to: 'kakomon_api#userScore', via:[:post]
  match '/kakomon/tsv', to: 'kakomon_api#tsv', via: [:post]
  match '/kakomon/regischool_tsv', to: 'kakomon_api#regischool_tsv', via: [:post]
  match '/kakomon/api/v0/school_list', to: 'kakomon_api#school_list', via: [:get]

  # 表示するページ
  match '/kakomon/batch', to: 'kakomon_api#batch', via:[:get]
  match '/kakomon/index', to: 'kakomon_api#index', via:[:get]
  match '/kakomon/answers', to: 'kakomon_api#answers', via:[:get]
  match '/kakomon/scores', to: 'kakomon_api#scores', via:[:get]
  match '/kakomon/scores/:id', to:'kakomon_api#delete_score', via:[:delete]
  match '/kakomon/register_school', to: 'kakomon_api#regi_school', via:[:get]
  match '/kakomon/schoolindex', to: 'kakomon_api#schoolindex', via:[:get]
  match '/kakomon/average/:year', to: 'kakomon_api#show_average', via:[:get]
  match '/kakomon/newdummy', to: 'kakomon_api#newdummy', via:[:get]
  match '/kakomon/dummytsv', to: 'kakomon_api#create_dummy_tsv', via:[:post]

  resources :correct_answers



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
