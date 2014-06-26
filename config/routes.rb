Moocchat::Application.routes.draw do
  mount JasmineRails::Engine => '/specs' if defined?(JasmineRails)

  # The priority is based upon order of creation:
  # first created -> highest priority.
  resources :conditions
  resources :activity_schemas
  resources :questions
  resources :templates
  #routes the landing page to be this static page we talked about
  root :to => 'tasks#static'
  #a simple get to redirect to this page
  get 'chat' => 'chat#chatpage'
  get 'test' => 'chat#chattest'
  get "static" => 'tasks#static', :as => "static"

  
  #for posting to armando's create
  post '/tasks' => 'tasks#create'

  root :to => 'tasks#static', :as => 'static'

  # login and establish a session
  post '/tasks/:learner_name/:activity_schema_id/:condition_id' => 'tasks#create', :as => 'task_create'
  post '/tasks' => 'tasks#create' # regular form posting


  # welcome page ("Welcome! Click to start your learning activity")
  get '/tasks/:id', :to => 'tasks#welcome', :as => 'task_welcome'

  # go to next page/view of a task
  post '/tasks/:id', :to => 'tasks#next_page', :as => 'task_next_page'

  # exit page of a task - when you finish it
  get '/tasks/:id/complete', :to => 'tasks#complete', :as => 'task_complete'

  # error encountered during task
  get '/tasks/error', :to => 'tasks#error', :as => 'task_error'

  # render current page of task
  get '/tasks/:id/page', :to => 'tasks#page', :as => 'task_page'

  # advance to next page of task
  post '/tasks/:id/page', :to => 'tasks#next_page', :as => 'task_next_page'

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
