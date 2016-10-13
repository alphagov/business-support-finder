require 'rails_helper'

RSpec.describe BusinessSupportController do
  describe "GET 'start'" do
    it "returns http success" do
      get 'start'
      expect(response).to be_success
    end

    it "should set correct expiry headers" do
      get :start

      expect(response.headers["Cache-Control"]).to eq("max-age=1800, public")
    end
  end

  describe "GET 'search'" do
    before(:each) do
      business_support_api_has_scheme(:scheme1)
    end

    it "returns http success" do
      get :search
      expect(response).to be_success
    end

    it "should set correct expiry headers" do
      get :search

      expect(response.headers["Cache-Control"]).to eq("max-age=1800, public")
    end
  end

  describe "common stuff for all actions" do
    controller(BusinessSupportController) do
      def index
        render :text => "something"
      end
    end

    it "should return 404 for invalid UTF-8 in params" do
      get :index, "sectors"=>"travel-and-leisure", "stage"=>"pre-start", "size"=>"under-10", "types"=>"acux10764\xC0\xBEz1\xC0\xBCz2a\x90bcxuca10764"

      expect(response.status).to eq(404)
    end
  end
end
