require 'spec_helper'

describe Area do

  include ImminenceApiHelper

  before do
    @regions = [{slug: "london", name: "London", type: "EUR", country_name: "England"},
                {slug: "south-east", name: "South East", type: "EUR", country_name: "England"},
                {slug: "england", name: "England", type: "EUR", country_name: "England"},
                {slug: "scotland", name: "Scotland", type: "EUR", country_name: "Scotland"},
                {slug: "wales", name: "Wales", type: "EUR", country_name: "Wales"},
                {slug: "northern-ireland", name: "Northern Ireland", type: "EUR", country_name: "Northern Ireland"}]

    stub_imminence_areas_request(@regions)
  end

  describe "all" do
    it "should memoize Imminence areas" do
      Area.class_eval('@areas = nil')

      expect(Area).to receive(:imminence_areas).once.and_call_original
      2.times { Area.all }
    end
    it "should return Imminence areas" do
      areas = Area.all
      areas.size.should == 4
      areas.map(&:name).should == ["England", "Scotland", "Wales", "Northern Ireland"]
      areas.map(&:regions).flatten.map(&:slug).should == ["england", "london", "south-east", "scotland", "wales", "northern-ireland"]
    end
  end

end
