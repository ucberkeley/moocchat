# For multithreaded web server, each Rails worker needs more than a single
# database connection available.  Ideally, there should be enough connections
# available to serve all concurrent threads.  Heroku imposes a limit of
# 20 total db connections for the basic db plans.  Puma runs with up to
# 16 threads per child worker, and we run a single child worker (even though
# it's possible to run >1 child per dyno).
Rails.application.config.after_initialize do
  ActiveRecord::Base.connection_pool.disconnect!

  ActiveSupport.on_load(:active_record) do
    config = ActiveRecord::Base.configurations[Rails.env] ||
                Rails.application.config.database_configuration[Rails.env]
    config['pool'] = ENV['PUMA_THREADS'] || ENV['MAX_THREADS'] || 16
    ActiveRecord::Base.establish_connection(config)
  end
end
