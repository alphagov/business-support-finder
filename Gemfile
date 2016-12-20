source 'https://rubygems.org'

gem 'rails', '~> 4.2', '>= 4.2.7.1'

gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 2.7.2'

gem 'slimmer', '10.0.0'
gem 'plek', '1.10.0'
if ENV['API_DEV']
  gem 'gds-api-adapters', path: '../gds-api-adapters'
else
  gem 'gds-api-adapters', '~> 37.2.0'
end

gem 'logstasher', '0.6.2'
gem 'airbrake', '~> 4.3.0'
gem 'unicorn'

gem 'govuk_navigation_helpers', '~> 2.0.0'

group :development, :test do
  gem 'rspec-rails', '~> 3.3'
  gem 'capybara', '~> 2.4.4'
  gem 'simplecov'
  gem 'simplecov-rcov'
  gem 'webmock', require: false
  gem 'nokogiri'
  gem 'pry-byebug'
  gem 'poltergeist', '~> 1.6.0'
  gem 'govuk-content-schema-test-helpers'
  gem 'govuk-lint'
end

gem 'govuk_frontend_toolkit', '1.3.0'
