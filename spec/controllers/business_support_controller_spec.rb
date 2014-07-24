require 'spec_helper'

describe BusinessSupportController do

  include ImminenceApiHelper

  before do
    stub_imminence_areas_request([])
  end
  describe "GET 'start'" do
    it "returns http success" do
      get 'start'
      response.should be_success
    end

    it "should set correct expiry headers" do
      get :start

      response.headers["Cache-Control"].should == "max-age=1800, public"
    end
  end

  describe "GET 'search'" do
    before(:each) do
      business_support_api_has_scheme(:scheme1)
    end

    it "returns http success" do
      get :search
      response.should be_success
    end

    it "should set correct expiry headers" do
      get :search

      response.headers["Cache-Control"].should == "max-age=1800, public"
    end
  end

  describe "common stuff for all actions" do
    controller(BusinessSupportController) do
      def index
        render :text => "something"
      end
    end

    it "should fetch the artefact and send it to slimmer" do
      artefact_data = artefact_for_slug(APP_SLUG)
      content_api_has_an_artefact(APP_SLUG, artefact_data)

      get :index

      response.headers[Slimmer::Headers::ARTEFACT_HEADER].should == artefact_data.to_json
    end

    it "should 503 if content_api times out" do
      WebMock.stub_request(:get, %r{\A#{GdsApi::TestHelpers::ContentApi::CONTENT_API_ENDPOINT}}).to_timeout

      get :index
      response.status.should == 503
    end

    it "should set the slimmer format header" do
      get :index

      response.headers["#{Slimmer::Headers::HEADER_PREFIX}-Format"].should == "finder"
    end

    it "should return 404 for invalid UTF-8 in params" do
      get :index, "sectors"=>"travel-and-leisure", "stage"=>"pre-start", "size"=>"under-10", "types"=>"acux10764\xC0\xBEz1\xC0\xBCz2a\x90bcxuca10764"

      response.status.should == 404
    end
  end
end
