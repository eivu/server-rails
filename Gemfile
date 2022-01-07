source 'https://rubygems.org'
ruby '2.7.2'

# i/o
gem 'aasm', '~> 5.2' # AASM is a continuation of the acts-as-state-machine
gem 'ancestry' # used to nest project_products by providing a parent_id and many convenience methods
gem 'attr_encrypted', '~> 3.1' # Generates attr_accessors that encrypt and decrypt attributes transparently
gem 'aws-sdk', '~> 2.0.41'
gem 'bitfields', '~> 0.6.0' # store multiple booleans in a single integer
gem 'devise', '~> 4.8' # user authentication
gem 'eivu-fingerprinter-acoustid', path: '/Users/jinx/projects/eivu/eivu_acoustid'
gem 'ensurance', '~> 0.1.19' # Add ability to "ensure" ActiveRecords are full records
gem 'has_secure_token' # generate the 24-character unique token
gem 'jb', '~> 0.4.1' # Faster and simpler Jbuilder alternative
gem 'mimemagic', '~> 0.3.5' # determine mime type by magic
gem 'mime-types', '~> 3.3', '>= 3.3.1' # rovides a library and registry for information about MIME content type definitions
gem 'mini_magick', '~> 4.5', '>= 4.5.1' # there's an issues with v3.7 https://github.com/carrierwaveuploader/carrierwave/issues/1282
gem 'oj' # faster json parsing
gem 'pg', '~> 1.2', '>= 1.2.3'
gem 'rails', '~> 6.1', '>= 6.1.3'
gem 'rest-client' #, '~> 1.8.0' # A simple HTTP and REST client for Ruby, inspired by the Sinatra microframework style of specifying actions
gem 'sidekiq', '~> 4.1', '>= 4.1.2' # Simple, efficient background processing for Ruby.
gem 'webpacker', '>= 4.0.x' # Use Webpack to manage app-like JavaScript modules in Rails

gem 'foreman', '~> 0.87.1' # Manage Procfile-based applications http://ddollar.github.com/foreman
# gem "rjson"  # templating for json (no version in gem because it doenst have any depenedencies)
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer',  platforms: :ruby

# Backgound Processing
gem 'activejob-traffic_control', '~> 0.1.3' # Traffic control for ActiveJob: Concurrency/enabling/throttling

# presentation
gem 'bootstrap-sass', '~> 3.4.1' # twitter bootstrap stylings
# gem 'coffee-rails', '~> 4.1.0'
gem 'jquery-rails' # Use jquery as the JavaScript library
gem 'sass-rails', '~> 5.0', '>= 5.0.4' # Use SCSS for stylesheets and useful for Sass-powered version of Bootstrap
gem 'uglifier', '~> 4.2' # has to be outside of assets, to its present at boot. Use Uglifier as compressor for JavaScript assets
# gem 'turbolinks' # Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks

# API
gem 'graphql', '~> 1.9', '>= 1.9.16'
# bundle exec rake doc:rails generates the API under doc/api.

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

group :development, :test, :cucumber do
  # gem 'spring' # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'better_errors'
  gem 'binding_of_caller' # irb on better-errors error pages
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
  gem 'rspec-rails', '~> 5.0', '>= 5.0.1'
  gem 'vcr', '~> 6.0'
end

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]

group :development do
  gem 'annotate', require: false
  gem 'graphiql-rails'
  gem 'puma', '~> 5.4'
end
