source 'https://rubygems.org'
source 'https://BnrJb6FZyzspBboNJzYZ@gem.fury.io/govuk/'

gem 'rails', '3.2.16'

gem 'slimmer', '3.20.0'
gem 'plek', '1.1.0'
if ENV['API_DEV']
  gem 'gds-api-adapters', :path => '../gds-api-adapters'
else
  gem 'gds-api-adapters', '7.25.0'
end

gem 'exception_notification'
gem 'aws-ses', :require => 'aws/ses'

gem 'logstasher', '0.4.0'
gem 'unicorn'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass', '3.2.0'
  gem 'sass-rails', '~> 3.2.3'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'
end

group :development, :test do
  gem 'rspec-rails', '2.14.0'
  gem 'capybara', '2.1.0'
  gem 'simplecov'
  gem 'simplecov-rcov'
  gem 'webmock', :require => false
  gem 'nokogiri'
  gem 'poltergeist', '1.4.1'
end

gem 'govuk_frontend_toolkit', '0.32.2'
