require 'spec_helper'

describe Location do

  describe "all" do
    it "should return all the hardcoded locations with slugs" do
      locations = Location.all

      locations.size.should == 4

      locations.map(&:name).should == ["England", "Scotland", "Wales", "Northern Ireland"]
      locations.map(&:slug).should == ["england", "scotland", "wales", "northern-ireland"]
    end
  end

  describe "find_by_slugs" do
    it "should return the instances that match the slugs" do
      locations = Location.find_by_slugs(%w(england wales))
      locations.first.name.should == "England"
      locations.last.name.should == "Wales"
    end

    it "should ignore non-existing values" do
      locations = Location.find_by_slugs(%w(england toyland wales))
      locations.map(&:name).should == ["England", "Wales"]
    end

    it "should return an empty array for non-existing slugs" do
      Location.find_by_slugs(%w(non-existing)).should == []
    end
  end

  it "should return the name for to_s" do
    Location.new(:name => "Fooey").to_s.should == "Fooey"
  end
end
