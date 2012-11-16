require 'spec_helper'

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

  describe "find_by_slug" do
    it "should return the instances that matches the slug" do
      location = Location.find_by_slug('wales')

      location.name.should == "Wales"
    end

    it "should return nil for a non-existing slug" do
      Location.find_by_slug('non-existing').should == nil
    end
  end

  it "should return the name for to_s" do
    Location.new(:name => "Fooey").to_s.should == "Fooey"
  end

end
