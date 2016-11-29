require 'rails_helper'

RSpec.describe PageContentItem do
  describe '#payload' do
    it 'is valid against the schema' do
      payload = PageContentItem.new.payload

      expect(payload).to be_valid_against_schema('generic')
    end

    it 'has the correct data' do
      payload = PageContentItem.new.payload

      expect(payload[:title]).to eql('Finance and support for your business')
    end
  end

  describe '#base_path' do
    it 'has the correct base path' do
      base_path = PageContentItem.new.base_path

      expect(base_path).to eql("/business-finance-support-finder")
    end
  end
end
