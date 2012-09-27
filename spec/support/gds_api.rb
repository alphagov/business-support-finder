require 'gds_api/test_helpers/content_api'
require 'gds_api/test_helpers/imminence'

RSpec.configure do |config|
  config.include GdsApi::TestHelpers::ContentApi, :type => :controller
  config.include GdsApi::TestHelpers::Imminence, :type => :controller
  config.before(:each, :type => :controller) do
    stub_content_api_default_artefact
    stub_imminence_default_business_support_schemes
  end

  config.include GdsApi::TestHelpers::ContentApi, :type => :request
  config.include GdsApi::TestHelpers::Imminence, :type => :request
  config.before(:each, :type => :request) do
    stub_content_api_default_artefact
    stub_imminence_default_business_support_schemes
  end
end
