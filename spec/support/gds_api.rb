require 'webmock'
require 'gds_api/test_helpers/business_support_api'
require 'gds_api/test_helpers/content_api'

RSpec.configure do |config|
  config.include GdsApi::TestHelpers::BusinessSupportApi, :type => :controller
  config.include GdsApi::TestHelpers::ContentApi, :type => :controller
  config.before(:each, :type => :controller) do
    stub_content_api_default_artefact
    setup_business_support_api_schemes_stubs
  end

  config.include GdsApi::TestHelpers::BusinessSupportApi, :type => :feature
  config.include GdsApi::TestHelpers::ContentApi, :type => :feature
  config.before(:each, :type => :feature) do
    stub_content_api_default_artefact
    setup_business_support_api_schemes_stubs
    setup_content_api_business_support_schemes_stubs
  end
end
