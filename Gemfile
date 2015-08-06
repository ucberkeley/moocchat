source 'https://rubygems.org'

ruby '1.9.3'
gem 'rails', '3.2.18'
gem 'puma'
gem 'faye-websocket'
gem 'haml'
gem 'omniauth'
gem 'omniauth-google-oauth2'
gem 'jquery-rails'
gem 'date_validator'            # datetime validations for ActiveRecord
gem 'foreman'
gem 'capybara-puma'
gem 'foreigner'			# foreign key support for rails
gem 'pg'
gem 'rack-p3p'
gem 'momentjs-rails'            # prereq of datetimepicker
gem 'bootstrap3-datetimepicker-rails'
gem 'rubyzip',  "~> 1.0.0"      # prereq of axlsx, axlsx 2.0.1 requires old version
gem 'axlsx', "~> 2.0.1"
gem 'axlsx_rails'
gem 'csv_builder'

group :development, :test do
  gem 'debugger'
  gem 'factory_girl_rails'
  gem 'railroady' # requires 'brew install graphviz' on mac or 'sudo apt-get install graphviz' on linux
  gem 'rspec-rails', '2.14.0'
  gem 'jasmine-rails', '0.9.1'
  gem 'jasmine-jquery-rails'
  gem 'metric_fu'
end

group :test do
  gem 'cucumber-rails', :require => false
  gem 'cucumber-rails-training-wheels'          # basic web steps like "I should see..."
  gem 'database_cleaner' # required by Cucumber
  gem 'autotest-rails'
  gem 'simplecov', :require => false
  gem 'timecop'
  gem 'cucumber-timecop', :require => false   # for testing code that relies on time of day
  gem 'selenium-webdriver' #for the javascript in static page(and any other javascript check)
  gem 'poltergeist'#used for headless-browser and js
end

group :production do
  gem 'rack-ssl-enforcer'
  gem 'newrelic_rpm'
  gem 'rails_12factor'
end


# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass', '3.2.13' #to remove the compile asset error
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'twitter-bootstrap-rails' #added the static bootstrap css
  #gem 'bootstrap-sass', '3.1.1.0'
  gem 'uglifier', '>= 1.0.3'
end
