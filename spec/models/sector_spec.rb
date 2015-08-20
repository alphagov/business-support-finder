require 'rails_helper'

RSpec.describe Sector do

  describe "all" do
    it "should return all the hardcoded sectors with slugs" do
      sectors = Sector.all

      expect(sectors.size).to eq(16)

      expect(sectors[0].name).to eq("Agriculture")
      expect(sectors[0].slug).to eq("agriculture")

      expect(sectors[6].name).to eq("Information, Communication and Media")
      expect(sectors[6].slug).to eq("information-communication-and-media")
    end
  end

end
