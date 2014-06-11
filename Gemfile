source 'https://rubygems.org'

ruby '1.9.3'
gem 'rails', '3.2.18'
gem 'haml'
gem 'omniauth'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

group :development, :test do
  gem 'webrick', '~> 1.3.1'
  gem 'sqlite3'
  gem 'debugger'
  gem 'railroady' # requires 'brew install graphviz' on mac or 'sudo apt-get install graphviz' on linux
  gem 'metric_fu'
end

group :test do
  gem 'rspec-rails'
  gem 'cucumber-rails', :require => false
  gem 'database_cleaner' # required by Cucumber
  gem 'autotest-rails'
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

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'debugger'
