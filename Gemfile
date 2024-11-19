source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '~> 2.5'

gem 'dotenv-rails', require: 'dotenv/rails-now'
gem 'rails', '~> 5.2.2'
gem 'puma', '~> 3.11'
gem 'discard', '~> 1.0'
gem 'jbuilder', '~> 2.5'
gem 'json-jwt'
gem 'jwt'
gem 'activerecord-import'
gem 'aws-sdk-s3'
gem 'aws-sdk-cognitoidentityprovider'
gem 'uuid'
gem 'mini_mime'
gem 'kaminari'
gem 'api-pagination'

gem 'daemons'
gem 'delayed_job_active_record'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
gem 'rack-cors'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'wdm' if Gem.win_platform?
  gem 'pry-rails'
end

group :mysql do
  gem 'mysql2'
end

group :sqlite do
  gem 'sqlite3', '> 1.3', '< 1.4'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

gem 'wicked_pdf'
# we need the new binary here, so that we can be OS independent
gem 'wkhtmltopdf-binary'

gem 'aes-everywhere'
