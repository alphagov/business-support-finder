require 'spec_helper'

describe Sector do

  describe "all" do
    it "should return all the hardcoded sectors with slugs" do
      sectors = Sector.all

      sectors.size.should == 16

      sectors[0].name.should == "Agriculture"
      sectors[0].slug.should == "agriculture"

      sectors[6].name.should == "Information, Communication and Media"
      sectors[6].slug.should == "information-communication-and-media"
    end
  end

  describe "find_by_slugs" do
    it "should return sector instances that match the slugs" do
      sectors = Sector.find_by_slugs(%w(mining real-estate))

      sectors.map(&:name).should == ["Mining", "Real Estate"]
    end

    it "should ignore non-existing slugs" do
      sectors = Sector.find_by_slugs(%w(mining non-existent real-estate))

      sectors.map(&:name).should == ["Mining", "Real Estate"]
    end

    it "should return empty array with no matching slugs" do
      sectors = Sector.find_by_slugs(%w(i-dont-exist fooey))

      sectors.should == []
    end
  end

  it "should return the name for to_s" do
    Sector.new(:name => "Fooey").to_s.should == "Fooey"
  end
end
