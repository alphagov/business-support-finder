require 'rails_helper'

RSpec.describe Scheme do
  describe "lookup" do
    it "should lookup schemes via the business support api" do
      expect(Scheme.business_support_api).to receive(:schemes)
        .with({:foo => "bar"}).and_return([:scheme1, :scheme2])
      expect(Scheme.lookup({:foo => "bar"})).to eq([:scheme1, :scheme2])

      expect(Scheme.business_support_api).to receive(:schemes)
        .with({}).and_return([:scheme1])
      expect(Scheme.lookup({})).to eq([:scheme1])
    end
  end
end
