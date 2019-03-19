source 'https://rubygems.org'

ruby '2.3.0'
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.1.10'
# Use SCSS for stylesheets
gem 'bootstrap-sass', '~> 3.3.6'
gem 'sass-rails', '>= 3.2'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'
gem "haml-rails", "~> 0.9"

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0',          group: :doc

# Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
gem 'spring',        group: :development

# Use devise for user authentication
gem 'devise'

# User rubyXL gem for reading and writing xlsx files
gem 'rubyXL'

# User roo gem for reading and writing xls files
gem 'roo'
gem 'roo-xls'

gem 'pdf-reader-turtletext' # Gem for parsing PDF reports

gem 'rake', group: :test # for TravisCI

gem 'cancancan' # for user class-based access

gem 'rolify' # to define user classes
gem 'delayed_job_active_record'
gem 'pg', '~> 0.20'

group :development, :test do
  # Use sqlite3 as the database for Active Record
  gem 'sqlite3'
  gem 'byebug'
  gem 'cucumber'
  gem 'cucumber-rails', :require => false
  gem 'cucumber-rails-training-wheels'
  gem 'database_cleaner'
  gem 'factory_girl_rails'
  gem 'rspec'
  gem 'rspec-rails', '~> 3.0'
  gem 'simplecov', :require => false
end

group :production do
  gem 'rails_12factor'
end
