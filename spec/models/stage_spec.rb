require 'spec_helper'

describe Stage do

  describe "all" do
    it "should return all the hardcoded stages with slugs" do
      stages = Stage.all

      stages.size.should == 3

      stages.map(&:name).should == ["Pre-start", "Start-up", "Grow and sustain"]
      stages.map(&:slug).should == ["pre-start", "start-up", "grow-and-sustain"]
    end
  end

end
