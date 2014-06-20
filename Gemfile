source 'https://rubygems.org'

ruby '1.9.3'
gem 'rails', '3.2.18'
gem 'capybara'
gem 'puma'
gem 'faye-websocket'
gem 'omniauth'
gem 'jquery-rails'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

group :development, :test do
  gem 'sqlite3'
  gem 'debugger'
  gem 'railroady' # requires 'brew install graphviz' on mac or 'sudo apt-get install graphviz' on linux
  gem 'rspec-rails', '2.14.0'
  gem 'metric_fu'
  gem 'selenium-webdriver' #for the javascript in static page(and any other javascript check)
  #gem 'therubyracer', :platforms => :ruby
end

group :test do
  gem 'cucumber-rails', :require => false
  gem 'cucumber-rails-training-wheels'          # basic web steps like "I should see..."
  gem 'database_cleaner' # required by Cucumber
  gem 'autotest-rails'
  gem 'factory_girl_rails'
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
  #gem 'twitter-bootstrap-rails'
  #gem 'libv8'
  #gem 'less'
  #gem 'less-rails'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes

  gem 'uglifier', '>= 1.0.3'
end


# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'debugger'g