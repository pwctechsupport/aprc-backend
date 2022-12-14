source 'https://rubygems.org'
source 'https://gems.veracode.com'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# ruby '2.5.3'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.4'
# Use sqlite3 as the database for Active Record
# gem 'sqlite3'
# Use Puma as the app server
gem 'puma'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
gem 'roo', ">= 2.5.1"
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'mini_racer', platforms: :ruby
gem 'paperclip'
gem 'axlsx_styler'
gem 'rolify'

gem 'hirb'

gem 'daemons'

gem 'delayed_job_active_record'


gem 'state_machines-activerecord'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
gem 'mysql2'
gem 'graphql_playground-rails'
gem 'wicked_pdf'
gem 'wkhtmltopdf-binary'

gem 'haml'
gem 'draftsman', '~> 0.7.1'
gem 'apollo_upload_server', '2.0.0.beta.3'

gem 'rubyzip'
gem 'axlsx'
gem 'axlsx_rails'
gem 'paper_trail'
gem 'paper_trail-association_tracking'
gem 'veracode'
# gem 'actioncable', '~> 0.0.0'

# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use ActiveStorage variant
# gem 'mini_magick', '~> 4.8'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

gem 'devise'                                # Use devise as authentication module
gem 'devise-jwt'                            # Use JWT token authentication with devise
gem 'bcrypt'                                # Use ActiveModel has_secure_password
gem 'graphql'
gem 'graphql-errors'
gem 'rack-cors'
gem 'graphql-pagination'
gem 'kaminari-activerecord'
gem 'ransack', '~> 2.4.1'
gem 'ancestry'
gem 'psych'
gem "safe_yaml"

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'capistrano',         require: false
  gem 'capistrano-rvm',     require: false
  gem 'capistrano-rails',   require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano3-puma',   require: false
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  # Easy installation and use of chromedriver to run system tests with Chrome
  gem 'chromedriver-helper'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

gem 'graphiql-rails', group: :development
gem 'bootstrap'
