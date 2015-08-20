require 'rails_helper'

describe Location do

  describe "all" do
    it "should return all the hardcoded locations with slugs" do
      locations = Location.all

      locations.size.should == 4

      locations.map(&:name).should == ["England", "Scotland", "Wales", "Northern Ireland"]
      locations.map(&:regions).flatten.map(&:slug).should == ["england", "london", "north-east", "north-west", "east-midlands",
        "west-midlands", "yorkshire-and-the-humber", "south-west", "east-of-england", "south-east",
        "scotland", "wales", "northern-ireland"]
    end
  end

end
