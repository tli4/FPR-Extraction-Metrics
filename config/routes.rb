Rails.application.routes.draw do

  get "/admin", to: "admin#index"

  devise_for :users
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):

  root :to => 'home#index'

  resources :admin do
    get 'change_to_admin'
    get 'change_to_guest'
    get 'change_to_read_only'
    get 'change_to_read_write'
    get 'remove_user'
  end

  resources :evaluation do
    get  'import',       on: :collection
    get  'import_gpr',   on: :collection
    get  'import_history', on: :collection
    get  'export',       on: :member
    get  'missing_data', on: :collection
    get  'show',         on: :collection
    post 'create',       on: :collection
    post 'upload',       on: :collection
    post 'upload_gpr',   on: :collection
    post 'upload_history', on: :collection
  end

  resources :instructor do
    get 'export',        on: :member
    get 'combine',       on: :collection
    post 'merge',        on: :collection
    get 'merge',        on: :collection
    post 'merge_confirm',        on: :collection
    get 'merge_confirm',        on: :collection
  end

  resources :course_name do
    get  'import',       on: :collection
    post 'upload',       on: :collection
  end

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
