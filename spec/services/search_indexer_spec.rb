require 'rails_helper'
require 'gds_api/test_helpers/rummager'

RSpec.describe SearchIndexer do
  include GdsApi::TestHelpers::Rummager

  before do
    stub_any_rummager_post
  end

  it 'indexes the business support page in rummager' do
    business_support_page = OpenStruct.new(BusinessSupportPage::DATA)
    described_class.call(business_support_page)

    assert_rummager_posted_item(
      _type: 'edition',
      _id: "/#{business_support_page.slug}",
      rendering_app: "businesssupportfinder",
      publishing_app: "businesssupportfinder",
      format: "custom-application",
      title: business_support_page.title,
      description: business_support_page.description,
      indexable_content: business_support_page.indexable_content,
      link: "/#{business_support_page.slug}"
    )
  end
end
