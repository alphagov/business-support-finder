require "spec_helper"

describe BusinessSupportHelper do
  describe "formatted_facet_values" do
    it "should return a space delimited string of facet values" do
      formatted_facet_values(["1,000,000"]).should == "1,000,000"
      formatted_facet_values(%w(Narnia Peckham)).should == "Narnia Peckham"
    end
    it "should return an empty string if the scheme has no facet values for the facet name" do
      formatted_facet_values([]).to_s.should == ""
      formatted_facet_values([]).to_s.should == ""
    end
  end
end
