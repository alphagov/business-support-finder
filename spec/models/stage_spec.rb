require 'spec_helper'

describe Stage do

  describe "all" do
    it "should return all the hardcoded stages with slugs" do
      stages = Stage.all

      stages.size.should == 4

      stages.map(&:name).should == ["Pre-start", "Start-up", "Grow and sustain", "Exiting a business"]
      stages.map(&:slug).should == ["pre-start", "start-up", "grow-and-sustain", "exiting-a-business"]
    end
  end

  describe "find_by_slug" do
    it "should return the instances that matches the slug" do
      stage = Stage.find_by_slug('pre-start')

      stage.name.should == "Pre-start"
    end

    it "should return nil for a non-existing slug" do
      Stage.find_by_slug('non-existing').should == nil
    end
  end

  it "should return the name for to_s" do
    Stage.new(:name => "Fooey").to_s.should == "Fooey"
  end
end
