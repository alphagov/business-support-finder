source 'https://rubygems.org'

gem 'rails', '3.2.3'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem "mongoid", "~> 2.4"
gem "bson_ext", "~> 1.5"

if ENV['API_DEV']
  gem 'gds-api-adapters', :path => '../gds-api-adapters'
else
  gem 'gds-api-adapters', '~> 0.2.0'
end

gem 'rummageable', '~> 0.1.3'

if ENV['SLIMMER_DEV']
  gem "slimmer", :path => '../slimmer'
else
  gem "slimmer", '1.2.3'
end

gem 'aws-ses', :require => 'aws/ses' # Needed by exception_notification
gem 'exception_notification'



# Gems used only for assets and not required
# in production environments by default.
group :assets do
end

group :development, :test do
  gem 'rspec-rails', '~> 2.10.0'
  gem 'factory_girl_rails', '~> 3.2.0'
  gem 'database_cleaner'
end

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'
