require 'rails_helper'

RSpec.describe Location do

  describe "all" do
    it "should return all the hardcoded locations with slugs" do
      locations = Location.all

      expect(locations.size).to eq(4)

      expect(locations.map(&:name)).to eq(["England", "Scotland", "Wales", "Northern Ireland"])
      expect(locations.map(&:regions).flatten.map(&:slug)).to eq(["england", "london", "north-east", "north-west", "east-midlands",
        "west-midlands", "yorkshire-and-the-humber", "south-west", "east-of-england", "south-east",
        "scotland", "wales", "northern-ireland"])
    end
  end

end
