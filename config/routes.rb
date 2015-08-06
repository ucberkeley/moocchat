Moocchat::Application.routes.draw do
  mount JasmineRails::Engine => '/specs' if defined?(JasmineRails)

  # The priority is based upon order of creation:
  # first created -> highest priority.
  resources :conditions
  resources :activity_schemas
  resources :questions
  resources :templates

  root :to => 'tasks#static', :as => 'root'

  # get next group-formation time for a given condition + activity_schema
  get '/group_formation_times/:activity_schema_id/:condition_id' =>
    'waiting_rooms#group_formation_times'

  # get seconds until next group formation timer expires
  # (should be consistent with actual current welcome screen timer)
  get '/seconds_to_next_group_formation/:activity_schema_id/' =>
    'waiting_rooms#seconds_to_next_group_formation'

  # Get current UTC timestamp by on this server's time.
  # Useful for client side time-based operations like scheduling windows.
  get '/get_current_timestamp_utc/' =>
    'waiting_rooms#get_current_timestamp_utc'

  # login as an authenticated user
  match '/auth/:provider/callback', :to => 'sessions#try_login'
  get '/auth/failure', :to => 'sessions#login_failed'
  post '/logout', :to => 'sessions#destroy'

  # login and establish a session
  post '/tasks/:learner_name/:activity_schema_id/:condition_id' => 'tasks#create', :as => 'task_create'
  post '/tasks' => 'tasks#create' # regular form posting
  get '/tasks/turk/:condition_id' => 'tasks#create_turk' # entry point for Turk workers

  # admin/test learner can force task to continue without waiting for WaitingRoom expiration
  post '/tasks/:id/force_continue', :to => 'tasks#force_continue', :as => 'task_force_continue'

  # Informs the server that a particular task has disconnected. Sent when another user in
  # the same group is not receiving heartbeats from this user.
  post '/tasks/:id/disconnect', :to => 'tasks#disconnect', :as => 'task_disconnect'

  # Sent to inform server that this task is still active. Sent shortly before the timer expires.
  post '/tasks/:id/heartbeat', :to => 'tasks#heartbeat', :as => 'task_heartbeat'

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

  # Record that a user has consented or rejected participation in the experiment - must use GET for JSONP
  get "users/record_consent"
  # Check whether a user has consented to participate in the experiment
  get "users/check_consent"

  # Reports
  get '/reports/chatlog' => 'reports#chatlog'
  post '/reports/chatlog/show' => 'reports#chatlog_show'
  get '/reports/sessions' => 'reports#sessions'
  post '/reports/sessions/show' => 'reports#sessions_show'

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

end
