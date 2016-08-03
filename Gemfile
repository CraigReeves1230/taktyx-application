source 'https://rubygems.org'


# Bundle Rails 5 racecar
gem 'rails', '~> 5.0.0.rc1'

# Use mysql as the database for Active Record
gem 'mysql2', '>= 0.3.13', '< 0.5'

# Use SCSS for css
gem 'sass-rails', '~> 5.0'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Image uploading
gem 'carrierwave', '~> 0.10.0'
gem 'mini_magick', '~> 4.3'

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'

# Gem used to create the event driven socket server
gem 'eventmachine'

# Assists in connecting web socket connections to event machine
gem 'em-websocket'

# Messaging service used with Takt server for push notifications
gem 'ffi-rzmq'

# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw]
gem 'sqlite3'

# Highly useful gem for checkboxes in particular
gem 'to_boolean', '1.0.2'

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'

# Gem for connecting to remote addresses
gem 'httparty'

# Gem for testing if two strings are similar
gem 'fuzzy-string-match'

# Useful gem to validate and format phone numbers
gem 'phony_rails'

# Gem to validate email addresses
gem 'email_validator'

# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# Allows us to pass variables to javascript easier
gem 'gon'

# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
gem 'puma'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
  gem 'pry'
end

group :production do
  gem 'pg',             '0.17.1'
  gem 'rails_12factor', '0.0.2'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end