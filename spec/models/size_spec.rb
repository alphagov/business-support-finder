require 'rails_helper'

RSpec.describe Size do

  describe "all" do
    it "should return all the hardcoded sizes with slugs" do
      sizes = Size.all

      expect(sizes.size).to eq(5)

      expect(sizes.map(&:name)).to eq(["0 - 9", "10 - 249", "250 - 500", "501 - 1000", "1000+"])
      expect(sizes.map(&:slug)).to eq(["under-10", "up-to-249", "between-250-and-500", "between-501-and-1000", "over-1000"])
    end
  end

end
