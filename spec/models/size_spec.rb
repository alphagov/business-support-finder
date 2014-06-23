require "spec_helper"

describe Size do

  describe "all" do
    it "should return all the hardcoded sizes with slugs" do
      sizes = Size.all

      sizes.size.should == 5

      sizes.map(&:name).should == ["0 - 9", "10 - 249", "250 - 500", "501 - 1000", "1000+"]
      sizes.map(&:slug).should == %w(under-10 up-to-249 between-250-and-500 between-501-and-1000 over-1000)
    end
  end

end
