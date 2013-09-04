require 'spec_helper'

describe Size do

  describe "all" do
    it "should return all the hardcoded sizes with slugs" do
      sizes = Size.all

      sizes.size.should == 5

      sizes.map(&:name).should == ["Under 10", "Up to 249", "Between 250 and 500", "Between 501 and 1000", "Over 1000"]
      sizes.map(&:slug).should == ["under-10", "up-to-249", "between-250-and-500", "between-501-and-1000", "over-1000"]
    end
  end

  describe "find_by_slug" do
    it "should return the instances that matches the slug" do
      size = Size.find_by_slug('under-10')

      size.name.should == "Under 10"
    end

    it "should return nil for a non-existing slug" do
      Size.find_by_slug('non-existing').should == nil
    end
  end

  it "should return the name for to_s" do
    Size.new(:name => "Fooey").to_s.should == "Fooey"
  end
end
