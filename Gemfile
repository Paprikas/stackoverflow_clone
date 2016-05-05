source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '>= 5.0.0.beta3', '< 5.1'
# Use postgresql as the database for Active Record
gem 'pg', '~> 0.18'
# Use Puma as the app server
gem 'puma'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5.x'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'pry-byebug'
  # TODO: Replace with stable when released
  gem 'rspec', '~> 3.5.0.beta3'
  gem 'rspec-rails', '~> 3.5.0beta3'
  gem 'factory_girl_rails'
  gem 'spring-commands-rspec'
  gem 'parallel_tests'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'better_errors'
  gem 'listen', '~> 3.0.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'quiet_assets'
  gem 'brakeman', require: false
  gem 'guard-rspec', '~> 4.6', require: false
  gem 'guard-bundler', require: false
  gem 'guard-rubocop', require: false
  gem 'guard-rails', require: false
  gem 'guard-spring', require: false
  gem 'pry-rails'
  gem 'thin'
end

group :test do
  gem 'rubocop', require: false
  gem 'rubocop-rspec'
  gem 'shoulda-matchers'
  gem 'rails-controller-testing'
  gem 'capybara'
  gem 'capybara-webkit'
  gem 'launchy'
  gem 'database_cleaner'
  gem 'codeclimate-test-reporter', require: false
  gem 'with_model'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

gem 'slim-rails'
# TODO: Replace with stable when released
gem 'devise', git: 'https://github.com/plataformatec/devise.git'

gem 'foundation-rails'
gem 'carrierwave'

# Replace with stable when released
gem 'rack', git: 'https://github.com/kikyous/rack.git'

# To help submit files with remote forms
# TODO: Replace with stable when released
gem 'remotipart', git: 'https://github.com/mshibuya/remotipart.git', ref: '3a6acb3'

# For nested forms
gem 'cocoon'
