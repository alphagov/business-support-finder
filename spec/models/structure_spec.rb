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

  describe "find_by_slug" do
    it "should return the instances that matches the slug" do
      structure = Structure.find_by_slug('partnership')

      structure.name.should == "Partnership"
    end

    it "should return nil for a non-existing slug" do
      Structure.find_by_slug('non-existing').should == nil
    end
  end

  it "should return the name for to_s" do
    Structure.new(:name => "Fooey").to_s.should == "Fooey"
  end
end
