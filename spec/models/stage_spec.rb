require 'spec_helper'

describe Stage do

  describe "all" do
    it "should return all the hardcoded stages with slugs" do
      stages = Stage.all

      stages.size.should == 4

      stages.map(&:name).should == ["Pre-startup", "Start-up", "Grow and sustain", "Exiting a business"]
      stages.map(&:slug).should == ["pre-startup", "start-up", "grow-and-sustain", "exiting-a-business"]
    end
  end

  describe "find_by_slugs" do
    it "should return the instances that match the slugs" do
      stages = Stage.find_by_slugs(%w(pre-startup start-up))
      stages.first.name.should == "Pre-startup"
      stages.last.name.should == "Start-up"
    end

    it "should ignore non-existing values" do
      stages = Stage.find_by_slugs(%w(grow-and-sustain crash-and-burn exiting-a-business))
      stages.map(&:name).should == ["Grow and sustain", "Exiting a business"]
    end

    it "should return an empty array for non-existing slugs" do
      Stage.find_by_slugs(%w(non-existing)).should == []
    end
  end

  it "should return the name for to_s" do
    Stage.new(:name => "Fooey").to_s.should == "Fooey"
  end
end
