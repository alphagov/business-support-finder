require 'rails_helper'

RSpec.describe Stage do
  describe "all" do
    it "should return all the hardcoded stages with slugs" do
      stages = Stage.all

      expect(stages.size).to eq(3)

      expect(stages.map(&:name)).to eq(["Pre-start", "Start-up", "Grow and sustain"])
      expect(stages.map(&:slug)).to eq(["pre-start", "start-up", "grow-and-sustain"])
    end
  end
end
