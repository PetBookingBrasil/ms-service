source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.5'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.0.2', '>= 6.0.2.2'
# Use sqlite3 as the database for Active Record
gem 'pg'
# Use Puma as the app server
gem 'puma', '~> 4.1'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
gem 'rack-cors'
gem 'enumerize', '~> 2.3', '>= 2.3.1'
gem 'friendly_id', '~> 5.3'
gem 'dotenv-rails', '~> 2.7.5'
gem 'whenever', require: false
gem 'grape'
gem 'grape-entity'
gem 'grape_on_rails_routes'
gem 'jwt'
gem 'ancestry'
gem 'searchkick', '~> 4.1.0'
gem 'mini_magick', '>= 4.2.4'
gem 'carrierwave'
gem 'carrierwave_backgrounder', github: 'lardawge/carrierwave_backgrounder'
gem 'carrierwave-base64'
gem 'sidekiq'
gem 'aasm'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]

  #customo gems
  gem 'rspec-rails', '~> 4.0.0'
  gem 'faker'
  gem 'pry-rails'
  gem 'pry-doc'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'

  #custom gems
  gem "better_errors"
  gem "binding_of_caller"
  gem 'brakeman'
  gem "capistrano", "~> 3.13", require: false
  gem 'annotate'
end

group :test do
  gem 'capybara'
  gem 'selenium-webdriver'
  gem 'webdrivers'

  #custom gems
  gem 'guard'
  gem 'guard-rspec'
  gem 'simplecov'
  gem 'factory_bot_rails'
  gem "slack-notifier"
  gem 'shoulda-matchers'
  gem 'rspec-collection_matchers'
  gem 'database_cleaner'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
