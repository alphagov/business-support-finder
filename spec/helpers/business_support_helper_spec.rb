require 'rails_helper'

RSpec.describe BusinessSupportHelper do
  describe "formatted_facet_values" do
    it "should return a space delimited string of facet values" do
      expect(formatted_facet_values(["1,000,000"])).to eq("1,000,000")
      expect(formatted_facet_values(%w(Narnia Peckham))).to eq('Narnia Peckham')
    end
    it "should return an empty string if the scheme has no facet values for the facet name" do
      expect(formatted_facet_values([]).to_s).to eq('')
      expect(formatted_facet_values([]).to_s).to eq('')
    end
  end
end
