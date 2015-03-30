source 'https://rubygems.org'

ruby '2.2.0'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.0'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

gem 'rails-observers'

# Use jquery as the JavaScript library
gem 'jquery-rails'
gem 'jquery-turbolinks'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

gem 'paperclip', '~> 4.2'
gem 'aws-sdk-v1'

gem 'simple_form'
gem "cocoon", '>= 1.2.0', git: 'https://github.com/nathanvda/cocoon'

gem 'bootstrap-sass', '~> 3.3.3'

gem 'devise'
gem 'cancancan', '~> 1.10'

gem 'momentjs-rails', '>= 2.9.0'
gem 'bootstrap3-datetimepicker-rails', '~> 4.0.0'

gem 'gettext_i18n_rails'

group :development do
  gem "better_errors"
  gem "binding_of_caller"
  gem 'gettext', '>=3.0.2', :require => false
  gem 'ruby_parser', :require => false
end

group :development, :test do
  # Use sqlite3 as the database for Active Record
  gem 'sqlite3'

  #use pry instead of normal rails c
  gem 'pry-rails'

  # Call 'pry-byebug' anywhere in the code to stop execution and get a debugger console
  gem 'pry-byebug'

  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'

  # Cucumber
  gem 'cucumber-rails', :require => false
  gem 'selenium-webdriver'
  # database_cleaner is not required, but highly recommended
  gem 'database_cleaner'

  gem 'factory_girl_rails'

  # RSpec
  gem 'rspec'
end

group :production do

  # needed for Heroku
  gem 'rails_12factor'

  # PostgreSQL
  gem 'pg'
end