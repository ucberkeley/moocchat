Moocchat::Application.routes.draw do
  mount JasmineRails::Engine => '/specs' if defined?(JasmineRails)

  # The priority is based upon order of creation:
  # first created -> highest priority.
  resources :conditions
  resources :activity_schemas
  resources :questions
  resources :templates

  #a simple get to redirect to this page
  get 'chat' => 'chat#chatpage'
  get 'test' => 'chat#chattest'

  root :to => 'tasks#static', :as => 'static'

  # get next group-formation time for a given condition + activity_schema
  get '/group_formation_times/:activity_schema_id/:condition_id' =>
    'waiting_rooms#group_formation_times'

  # login and establish a session
  post '/tasks/:learner_name/:activity_schema_id/:condition_id' => 'tasks#create', :as => 'task_create'
  post '/tasks' => 'tasks#create' # regular form posting

  # admin/test learner can force task to continue without waiting for WaitingRoom expiration
  post '/tasks/:id/force_continue', :to => 'tasks#force_continue', :as => 'task_force_continue'

  # error encountered while creating task
  get '/tasks/error', :to => 'tasks#error', :as => 'task_error'

  # welcome page ("Welcome! Click to start your learning activity")
  get '/tasks/:id', :to => 'tasks#welcome', :as => 'task_welcome'

  # go to first page/view of a task
  post '/tasks/:id/join_group', :to => 'tasks#join_group', :as => 'task_join_group'

  # exit page of a task - when you finish it
  get '/tasks/:id/complete', :to => 'tasks#complete', :as => 'task_complete'

  # render current page of task
  get '/tasks/:id/page', :to => 'tasks#page', :as => 'task_page'

  # record user's response (AJAX XHR)
  post '/tasks/:id/collect_response', :to => 'tasks#collect_response', :as => 'task_collect_response'

  # advance to next page of task
  post '/tasks/:id/next_page', :to => 'tasks#next_page', :as => 'task_next_page'

  # AJAX endpoint to log an event recorded at client
  post '/tasks/:id/log', :to => 'tasks#log', :as => 'task_log_event'

  # Record that a user has consented or rejected participation in the experiment
  get "users/record_consent"
  # Check whether a user has consented to participate in the experiment
  get "users/check_consent"

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

end
