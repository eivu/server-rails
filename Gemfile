# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| 'https://github.com/#{repo}.git' }

ruby '3.0.2'

gem 'aasm', '~> 5.2' # AASM is a continuation of the acts-as-state-machine
gem 'ancestry' # used to nest project_products by providing a parent_id and many convenience methods
gem 'aws-sdk-s3', '~> 1.111', '>= 1.111.1'
# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem 'bcrypt', '~> 3.1.7'
gem 'bootsnap', require: false # Reduces boot times through caching; required in config/boot.rb
gem 'devise', '~> 4.8' # user authentication
# gem 'eivu-fingerprinter-acoustid', path: '/Users/jinx/projects/eivu/eivu_acoustid'
# gem 'image_processing', '~> 1.2' # Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# unused? gem 'has_secure_token' # generate the 24-character unique token

gem 'hotwire-rails', '~> 0.1.3' # html over the wire
gem 'importmap-rails', '~> 1.0', '>= 1.0.1' # Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem 'oj' # faster json parsing
gem 'pg', '~> 1.2', '>= 1.2.3' # Use postgresql as the database for Active Record
gem 'puma', '~> 5.6' # Use the Puma web server [https://github.com/puma/puma]
gem 'rails', '~> 7.0.2.4'
gem 'redis', '~> 4.0' # Use Redis adapter to run Action Cable in production
gem 'sprockets-rails' # The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem 'stimulus-rails', '~> 1.0', '>= 1.0.2' # Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem 'strong_migrations', '~> 0.7.9'
gem 'turbo-rails', '~> 1.0' # Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby] # Windows does not include zoneinfo files, so bundle the tzinfo-data gem

# Backgound Processing
gem 'activejob-traffic_control', '~> 0.1.3' # Traffic control for ActiveJob: Concurrency/enabling/throttling
gem 'sidekiq', '~> 5.2' # Simple, efficient background processing for Ruby.

# presentation
gem 'formtastic', '~> 4.0.0.rc1'
gem 'formtastic-bootstrap', '~> 3.1', '>= 3.1.1'
gem 'bootstrap-sass', '~> 3.4.1' # twitter bootstrap stylings
# gem 'coffee-rails', '~> 4.1.0'
gem 'jquery-rails' # Use jquery as the JavaScript library
gem 'sass-rails', '~> 6.0' # Use SCSS for stylesheets and useful for Sass-powered version of Bootstrap
# gem 'uglifier', '~> 4.2' # has to be outside of assets, to be present at boot. Use Uglifier as compressor for JavaScript assets
gem 'will_paginate-bootstrap', '~> 1.0', '>= 1.0.2' # pagination library with built in bootstrap support

# API
gem 'graphql', '~> 1.9', '>= 1.9.16'
gem 'jb', '~> 0.4.1' # Faster and simpler Jbuilder alternative
gem 'jbuilder' # Build JSON APIs with ease [https://github.com/rails/jbuilder]

# Security
gem 'active_model_otp'
gem 'rack-cors'
gem 'rqrcode'

group :doc do
  gem 'sdoc', '~> 2.3'
end

group :production do
  gem 'rails_12factor'
end

group :development do
  # gem 'spring' # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'better_errors'
  gem 'binding_of_caller' # irb on better-errors error pages
  gem 'rack-mini-profiler' # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  gem 'web-console', '>= 4.1.0'
end

group :development, :test, :cucumber do
  gem 'factory_bot_rails', '~> 6.2'
  gem 'faker', '~> 2.18' # Faker, a port of Data::Faker from Perl, is used to easily generate fake data: names, addresses, phone numbers, etc.
  gem 'pry-byebug' # replaces pry-debugger becasuse pry-debugger doesnt work with ruby 2
  gem 'pry-rails'
  gem 'rb-readline'
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'coffee-rails'
end

group :test do
  gem 'database_cleaner', require: false
  gem 'db-query-matchers'
  gem 'graphql-client'
  gem 'rails-controller-testing'
  gem 'rspec-json_expectations', '~> 2.2'
  gem 'rspec-rails', '~> 5.0.2'
  gem 'table_print'
  gem 'vcr', '~> 6.0'
  # gem 'capybara'
  # gem 'selenium-webdriver'
  # gem 'webdrivers'
end

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem 'kredis'
