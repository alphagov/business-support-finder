require 'rails_helper'

RSpec.describe PublishingApiNotifier do
  describe '#publish' do
    it 'publishes the content item' do
      allow(Services.publishing_api).to receive(:put_content_item)

      PublishingApiNotifier.new.publish

      expect(Services.publishing_api).to have_received(:put_content_item).with(
        "/business-finance-support-finder",
        be_valid_against_schema('placeholder')
      )
    end
  end
end
