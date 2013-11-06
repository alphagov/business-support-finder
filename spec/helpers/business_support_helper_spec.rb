require 'spec_helper'

describe BusinessSupportHelper do
  describe "formatted_facet_values" do
    it "should return a space delimited string of facet values" do
      scheme = Scheme.new(:business_size => ["1,000,000"], :location => ["Narnia", "Peckham"])
      formatted_facet_values(scheme.business_size).should == "1,000,000"
      formatted_facet_values(scheme.location).should == 'Narnia Peckham'
    end
    it "should return an empty string if the scheme has no facet values for the facet name" do
      scheme = Scheme.new
      formatted_facet_values(scheme.business_size).to_s.should == ''
      formatted_facet_values(scheme.location).to_s.should == ''
    end
  end
end
