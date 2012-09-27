source 'https://rubygems.org'

gem 'rails', '3.2.8'

gem 'slimmer', '3.3.3'
gem 'plek', '0.4.0'
gem 'gds-api-adapters', '2.5.0'

gem 'exception_notification'
gem 'aws-ses', :require => 'aws/ses'

gem 'lograge'
gem 'unicorn'

# Gems used only for assets and not required
# in production environments by default.
group :assets do

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'
end

group :development, :test do
  gem 'rspec-rails', '2.11.0'
  gem 'capybara', '1.1.2'
  gem 'simplecov'
  gem 'simplecov-rcov'
  gem 'webmock', :require => false
  gem 'nokogiri'
  gem 'poltergeist', '0.7.0'
end
