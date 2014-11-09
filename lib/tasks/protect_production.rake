if Rails.env == 'production'
  tasks = Rake.application.instance_variable_get '@tasks'
  namespace :db do
    %w(reset drop seed create setup).each do |task_name|
      full_task_name = "db:#{task_name}"
      tasks.delete full_task_name
      task task_name.to_sym do
        desc "#{full_task_name} disabled in production"
        puts "#{full_task_name} has been disabled in #{Rails.env} environment"
      end
    end
  end
end
