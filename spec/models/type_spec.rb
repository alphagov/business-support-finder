require "spec_helper"

describe Type do

  describe "all" do
    it "should return all the hardcoded types with slugs" do
      types = Type.all

      types.size.should == 6
      types.map(&:name).should == ["Finance (any)", "Equity", "Grant", "Loan (including guarantees)", "Expertise and advice", "Recognition award"]
      types.map(&:slug).should == %w(finance equity grant loan expertise-and-advice recognition-award)
    end
  end

end
