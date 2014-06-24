source 'https://rubygems.org'

ruby '1.9.3'
gem 'rails', '3.2.18'
gem 'capybara'
gem 'puma'
gem 'faye-websocket'
gem 'omniauth'
gem 'jquery-rails'
gem 'date_validator'            # datetime validations for ActiveRecord
gem 'foreman'

group :development, :test do
  gem 'sqlite3'
  gem 'debugger'
  gem 'railroady' # requires 'brew install graphviz' on mac or 'sudo apt-get install graphviz' on linux
  gem 'rspec-rails', '2.14.0'
  gem 'metric_fu'
end

group :test do
  gem 'cucumber-rails', :require => false
  gem 'cucumber-rails-training-wheels'          # basic web steps like "I should see..."
  gem 'database_cleaner' # required by Cucumber
  gem 'autotest-rails'
  gem 'factory_girl_rails'
  gem 'simplecov', :require => false
  gem 'timecop'                 # for testing code that relies on time of day
  gem 'selenium-webdriver' #for the javascript in static page(and any other javascript check)
end

group :production do
  gem 'rails_12factor'
  gem 'pg'
end


# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'twitter-bootstrap-rails' #added the static bootstrap css
  gem 'uglifier', '>= 1.0.3'
end
