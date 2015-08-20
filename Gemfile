source 'https://rubygems.org'

gem 'rails', '4.2.3'

gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'

gem 'slimmer', '8.3.0'
gem 'plek', '1.10.0'
if ENV['API_DEV']
  gem 'gds-api-adapters', :path => '../gds-api-adapters'
else
  gem 'gds-api-adapters', '20.1.1'
end

gem 'logstasher', '0.4.8'
gem 'airbrake', '3.1.15'
gem 'unicorn'

group :development, :test do
  gem 'rspec-rails', '~> 3.3'
  gem 'capybara', '~> 2.4.4'
  gem 'simplecov'
  gem 'simplecov-rcov'
  gem 'webmock', :require => false
  gem 'nokogiri'
  gem 'poltergeist', '~> 1.6.0'
end

gem 'govuk_frontend_toolkit', '1.3.0'
