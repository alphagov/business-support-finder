require 'spec_helper'

describe Location do

  describe "all" do
    it "should return all the hardcoded locations with slugs" do
      locations = Location.all

      locations.size.should == 13 

      locations.map(&:name).should == ["England", "London", "North East (England)", "North West (England)",
        "East Midlands (England)", "West Midlands (England)", "Yorkshire and the Humber", "South West (England)",
        "East of England", "South East (England)", "Scotland", "Wales", "Northern Ireland"]
      locations.map(&:slug).should == ["england", "london", "north-east", "north-west", "east-midlands",
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
