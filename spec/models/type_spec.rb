require 'rails_helper'

RSpec.describe Type do

  describe "all" do
    it "should return all the hardcoded types with slugs" do
      types = Type.all

      expect(types.size).to eq(6)
      expect(types.map(&:name)).to eq(["Finance (any)", "Equity", "Grant", "Loan (including guarantees)", "Expertise and advice", "Recognition award"])
      expect(types.map(&:slug)).to eq(["finance", "equity", "grant", "loan", "expertise-and-advice", "recognition-award"])
    end
  end

end
