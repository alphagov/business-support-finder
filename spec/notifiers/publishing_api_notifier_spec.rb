require 'rails_helper'

RSpec.describe PublishingApiNotifier do
  describe '#publish' do
    it 'publishes the content item' do
      allow(Services.publishing_api).to receive(:put_content)
      allow(Services.publishing_api).to receive(:publish)
      allow(Services.publishing_api).to receive(:patch_links)

      PublishingApiNotifier.new.publish

      expect(Services.publishing_api).to have_received(:put_content) do |content_id, payload|
        expect(content_id).to eql("6f34c053-2f99-48a3-81e3-955fae00df69")
        expect(payload).to be_valid_against_schema('generic')
      end

      expect(Services.publishing_api).to have_received(:publish)

      expect(Services.publishing_api).to have_received(:patch_links) do |content_id, payload|
        expect(content_id).to eql("6f34c053-2f99-48a3-81e3-955fae00df69")
        expect(payload).to be_valid_against_links_schema('generic')
        expect(payload[:links][:meets_user_needs]).to eql(["713b3524-1c48-418c-baa2-25fb35395401"])
      end
    end
  end
end
