source "https://rubygems.org"

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem "rails", "5.0.1"
# Use postgresql as the database for Active Record
gem "pg", "~> 0.18"
# Use Puma as the app server
gem "puma"
# Use SCSS for stylesheets
gem "sass-rails", "~> 5.0"
# Use Uglifier as compressor for JavaScript assets
gem "uglifier", ">= 1.3.0"
# Use CoffeeScript for .coffee assets and views
gem "coffee-rails", "~> 4.1.0"

# Use jquery as the JavaScript library
gem "jquery-rails"
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem "turbolinks", "~> 5.x"
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem "jbuilder", "~> 2.0"

group :development, :test do
  gem "factory_girl_rails"
  gem "parallel_tests"
  gem "pry-byebug"
  gem "rspec"
  gem "rspec-rails"
  gem "spring-commands-rspec"
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem "better_errors"
  gem "binding_of_caller"
  gem "brakeman", require: false
  gem "guard-bundler", require: false
  gem "guard-rails", require: false
  gem "guard-rspec", "~> 4.6", require: false
  gem "guard-rubocop", require: false
  gem "guard-spring", require: false
  gem "listen", "~> 3.0.5"
  gem "pry-rails"
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"

  gem "capistrano", require: false
  gem "capistrano-bundler", require: false
  gem "capistrano-rails", require: false
  gem "capistrano-rbenv", require: false
  gem "capistrano-sidekiq", require: false
  gem "capistrano3-puma", require: false
end

group :test do
  gem "capybara"
  gem "capybara-email"
  gem "codeclimate-test-reporter", require: false
  gem "database_cleaner"
  gem "json_spec"
  gem "launchy"
  gem "poltergeist"
  gem "rails-controller-testing"
  gem "rubocop", require: false
  gem "rubocop-rspec"
  gem "shoulda-matchers"
  gem "with_model"
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]

gem "carrierwave"
gem "devise"
gem "foundation-rails"
gem "slim-rails"

# To help submit files with remote forms
gem "remotipart"

# For nested forms
gem "cocoon"

# JS templating
gem "gon"
gem "skim"

# Skinny controllers
gem "responders"

gem "omniauth", "~> 1.3.2"
gem "omniauth-facebook"
gem "omniauth-twitter"

# Authorization
gem "doorkeeper", "4.2.6"
gem "pundit"

gem "active_model_serializers", "~> 0.10.7"

# to_json replacement
gem "oj"
gem "oj_mimic_json"

# Delayed jobs
gem "sidekiq"
gem "whenever"

# Full-text search
gem "mysql2", "~> 0.3.18"
gem "thinking-sphinx", "~> 3.2.0"

gem "dotenv-rails"

# Caching
gem "redis-rails"
