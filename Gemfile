source 'http://rubygems.org'

gem 'rails', '3.1.3'

# Bundle edge Rails instead:
# gem 'rails',     :git => 'git://github.com/rails/rails.git'


gem 'haml', '~> 3.0'
gem 'dynamic_form'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'therubyracer'
  gem 'sass-rails',   '~> 3.1.5'
  gem 'coffee-rails', '~> 3.1.1'
  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# Use unicorn as the web server
gem 'unicorn'

# Deploy with Capistrano
gem 'capistrano', '~> 2.5'
gem 'flipstone-deployment', git: 'git://github.com/flipstone/flipstone-deployment.git', branch: 'ccc7a75'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'

group :test, :development do
  gem 'sqlite3'
  gem 'simplecov'
  gem 'webrat'
  gem "factory_girl"
  gem "factory_girl_rails"
  gem "rspec-rails"
end

group :test do
  gem 'fakeweb'
  # Pretty printed test output
  gem 'turn', '0.8.2', :require => false
end

group :production do
  gem 'mysql', '2.8.1'
end
