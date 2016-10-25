require 'webmock'
require 'gds_api/test_helpers/business_support_api'
require 'gds_api/test_helpers/business_support_helper'
require 'gds_api/test_helpers/content_store'

RSpec.configure do |config|
  config.include GdsApi::TestHelpers::BusinessSupportApi
  config.include GdsApi::TestHelpers::ContentStore
  config.before(:each) do
    content_store_has_item("/#{APP_SLUG}")
    setup_business_support_api_schemes_stubs
  end
end
