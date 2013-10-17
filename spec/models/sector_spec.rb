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

end
