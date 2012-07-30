require 'spec_helper'

describe FinanceFinderController do

  describe "GET to index" do
    before :each do
      5.times { |idx| FactoryGirl.create(:business_support, title: "Example Business Support #{idx + 1}") }
      get 'index'
    end
    it "returns HTTP success" do
      response.should be_success
    end
    it "finds business support records" do
      assert assigns[:finance_supports].size == 5
    end
    it "orders business support records by title" do
      assert_equal "Example Business Support 1", assigns[:finance_supports].first.title
      assert_equal "Example Business Support 2", assigns[:finance_supports].second.title
      assert_equal "Example Business Support 3", assigns[:finance_supports].third.title
    end
  end

end
