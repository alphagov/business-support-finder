require 'spec_helper'

describe Type do

  describe "all" do
    it "should return all the hardcoded types with slugs" do
      types = Type.all

      types.size.should == 6
      types.map(&:name).should == ["Finance (any)", "Equity", "Grant", "Loan (including guarantees)", "Expertise and advice", "Recognition award"]
      types.map(&:slug).should == ["finance", "equity", "grant", "loan", "expertise-and-advice", "recognition-award"]
    end
  end

  describe "find_by_slugs" do
    it "should return type instances that match the slugs" do
      types = Type.find_by_slugs(%w(finance recognition-award))

      types.map(&:name).should == ["Finance (any)", "Recognition award"]
    end

    it "should ignore non-existing slugs" do
      types = Type.find_by_slugs(%w(finance non-existent recognition-award))

      types.map(&:name).should == ["Finance (any)", "Recognition award"]
    end

    it "should return empty array with no matching slugs" do
      types = Type.find_by_slugs(%w(i-dont-exist fooey))

      types.should == []
    end
  end

  it "should return the name for to_s" do
    Type.new(:name => "Fooey").to_s.should == "Fooey"
  end
end
