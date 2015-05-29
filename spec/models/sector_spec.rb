require 'spec_helper'

describe Sector do

  describe "all" do
    it "should return all the hardcoded sectors with slugs" do
      sectors = Sector.all

      sectors.size.should == 20

      sectors[0].name.should == "Agriculture, fishing and forestry"
      sectors[0].slug.should == "agriculture"

      sectors[6].name.should == "Medical, mental health, addiction and social work"
      sectors[6].slug.should == "health"
    end
  end

end