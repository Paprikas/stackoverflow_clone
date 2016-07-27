source "https://rubygems.org"

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem "rails", ">= 5.0.0", "< 5.1"
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
  gem "pry-byebug"
  gem "rspec", "~> 3.5.0.beta3"
  gem "rspec-rails", "~> 3.5.0beta3"
  gem "factory_girl_rails"
  gem "spring-commands-rspec"
  gem "parallel_tests"
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem "better_errors"
  gem "binding_of_caller"
  gem "listen", "~> 3.0.5"
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
  gem "brakeman", require: false
  gem "guard-rspec", "~> 4.6", require: false
  gem "guard-bundler", require: false
  gem "guard-rubocop", require: false
  gem "guard-rails", require: false
  gem "guard-spring", require: false
  gem "pry-rails"

  gem "capistrano", require: false
  gem "capistrano-bundler", require: false
  gem "capistrano-rbenv", require: false
  gem "capistrano-rails", require: false
  gem "capistrano3-puma", require: false
  gem "capistrano-sidekiq", require: false
end

group :test do
  gem "rubocop", require: false
  gem "rubocop-rspec"
  gem "shoulda-matchers"
  gem "rails-controller-testing"
  gem "capybara"
  gem "poltergeist"
  gem "launchy"
  gem "database_cleaner"
  gem "codeclimate-test-reporter", require: false
  gem "with_model"
  gem "capybara-email"
  gem "json_spec"
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]

gem "slim-rails"
gem "devise"
gem "foundation-rails"
gem "carrierwave"

# To help submit files with remote forms
gem "remotipart", git: "https://github.com/mshibuya/remotipart.git", ref: "3a6acb3"

# For nested forms
gem "cocoon"

# JS templating
gem "skim"
gem "gon"

# Skinny controllers
gem "responders"

gem "omniauth"
gem "omniauth-facebook"
gem "omniauth-twitter"

# Authorization
gem "pundit"
gem "doorkeeper"

gem "active_model_serializers"

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
