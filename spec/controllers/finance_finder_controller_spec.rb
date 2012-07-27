require 'spec_helper'

describe FinanceFinderController do

  describe "GET to index" do
    before :each do
      5.times { |idx| FactoryGirl.create(:business_support, title: "Example Business Support #{idx}") }
      get 'index'
    end
    it "returns HTTP success" do
      response.should be_success
    end
    it "finds business support records" do
      assert assigns[:finance_supports].size == 5
    end
  end

end
