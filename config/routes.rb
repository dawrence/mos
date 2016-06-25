Mos::Application.routes.draw do

  get "users", to: "users#index"
  get "new_user", to: 'users#new'
  get "edit_user", to: 'users#edit'
  post "users", to: 'users#create'
  put "user", to: 'users#update', path: "user/:id"
  post "reset_password", to: 'users#reset_password'
  delete "user", to: 'users#destroy', path: "user/:id"

  get "my_data", to: 'users#my_data'
  put "update_my_data", to: 'users#update_my_data'

  get "closing_stages/index"

  get "closing_stages/create"

  resources :closing_stages, only: [:index, :create]
  resources :expenses, except: [:edit, :update, :destroy]
  resources :settings

  resources :kitchens

  resources :discount_vouchers


  devise_for :users

  root to: "bills#index"
  resources :tables

  get  "pay_bill", to: "payments#new"
  put  "pay_bill", to: "payments#pay_all"


  get 'bill_split', to: 'bills#split'
  post 'bill_split', to: 'bills#submit_split'

  post 'group_bills', to: 'tables#group_bills'
  
  get  "print_bill", to: "bills#print"
  put  "pending_bill", to: "bills#pending_bill"
  get  "print_z_report", to: "bills#z_report"
  get  "cancel_form_bill", to: "bills#cancel_form"
  get "supplies_sumarize", to: "supplies#supplies_sumarize"
  
  put  "bills/edit_table", to: "bills#edit_table", as: "view_cng_table"
  put  "bills/update_table", to: "bills#update_table", as: "cng_table"

  get "bills/validates", to: "bills#validates", as: "vld_bill"

  resources :bills

  get "closeout", to: "bills#closeout", as: "closeout"
  get "bills_report", to: "bills#bills_report", as: "bills_report"

  resources :inventory_movements
  post "inventory_movements_massive", to: "inventory_movements#massive_insert"

  resources :menu_products

  resources :supplies

  get "products/show_ingredients"

  get "details_by_supply", to: "inventory_movements#details_by_supply", as: "inv_det_spl"

  get "kitchen_view", to: "kitchens#view_kitchen"
  get "control_kitchen", to: "kitchens#control_kitchen"
  get "reload_kitchen", to: "kitchens#reload_kitchen"
  post "remove_bill", to: "kitchens#remove_bill"
  post "prepared_bill", to: "bills#prepared_bill"
  post "unlock_bill", to: "bills#unlock_bill"

  get "products/check_availability", to: "products#check_availability", as: "vld_prod"



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
