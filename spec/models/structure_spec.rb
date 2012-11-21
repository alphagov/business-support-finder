require 'spec_helper'

describe Structure do

  describe "all" do
    it "should return all the hardcoded structures with slugs" do
      structures = Structure.all

      structures.size.should == 6

      structures.map(&:name).should == ["Private company", "Partnership", "Public limited company", "Sole trader", "Social enterprise", "Charity"]
      structures.map(&:slug).should == ["private-company", "partnership", "public-limited-company", "sole-trader", "social-enterprise", "charity"]
    end
  end
  
  describe "find_by_slugs" do
    it "should return the instances that match the slugs" do
      structures = Structure.find_by_slugs(%w(private-company charity))
      structures.first.name.should == "Private company"
      structures.last.name.should == "Charity"
    end

    it "should ignore non-existing values" do
      structures = Structure.find_by_slugs(%w(private-company partnership non-existing))
      structures.map(&:name).should == ["Private company", "Partnership"]
    end

    it "should return an empty array for non-existing slugs" do
      Structure.find_by_slugs(%w(non-existing)).should == []
    end
  end
 
  it "should return the name for to_s" do
    Structure.new(:name => "Fooey").to_s.should == "Fooey"
  end
end
