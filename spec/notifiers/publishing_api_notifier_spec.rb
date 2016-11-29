require 'rails_helper'

RSpec.describe PublishingApiNotifier do
  describe '#publish' do
    it 'publishes the content item' do
      allow(Services.publishing_api).to receive(:put_content)
      allow(Services.publishing_api).to receive(:publish)

      PublishingApiNotifier.new.publish

      expect(Services.publishing_api).to have_received(:put_content) do |content_id, payload|
        expect(content_id).to eql("6f34c053-2f99-48a3-81e3-955fae00df69")
        expect(payload).to be_valid_against_schema('generic')
      end

      expect(Services.publishing_api).to have_received(:publish)
    end
  end
end
