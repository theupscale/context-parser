DrdoNewsReader::Application.routes.draw do
  
  get "url_dumps/today"
  
  get "url_dumps/delete_link"
  
  get "url_dumps/reprocess"

  get "rss_urls/delete"
  
  get "pages/about"

  get "pages/faq"

  get "pages/help"

  get "home/index"

  get "home/search"
  
  post "home/search"

  get "home/context"

  get "url_patterns/index"

  get "url_patterns/new"

  get "url_patterns/create"

  get "url_patterns/edit"

  get "url_patterns/update"

  get "url_patterns/delete"

  get "sources/index"

  get "sources/new"

  get "sources/create"

  get "sources/edit"

  get "sources/update"

  get "sources/delete"

  get "keywords/alias"
  
  get "keyword_rules/delete"
  
  get "keyword_contexts/delete"
  
  get "keywords/delete"
 
  get "categories/delete"
  
  match "keyword_contexts/test_rules"=> "keyword_contexts#test_rules"
  
  match "keyword_contexts/do_test"=> "keyword_contexts#do_test"
  
  match "keyword_contexts/create_rule/:id" => "keyword_contexts#create_rule"
  
  match "source/test_urls" => "sources#test_urls"
  
  match "sources/test_urls" => "sources#test_urls"
  
  resources :keywords
    
  resources :categories
  
  resources :keyword_contexts
  
  resources :keyword_rules
  
  resources :sources
  
  resources :url_patterns
  
  resources :rss_urls

  get "categories/index"

  get "categories/create"

  get "keywords/index"

  get "keywords/create"
  
  root :to => 'home#index'
  
  match 'admin' => 'admin#admin_index'

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
  

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  match ':controller(/:action(/:id))(.:format)'
end
