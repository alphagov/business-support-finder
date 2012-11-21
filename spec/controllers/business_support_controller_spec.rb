require 'spec_helper'

describe BusinessSupportController do
  before :each do
    @question1 = "What is your activity or business?"
    @question2 = "What stage is your business at?"
    @question3 = "How is your business structured?"
    @question4 = "What type of support are you interested in?"
    @question5 = "Where is your business located?"
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

  describe "GET 'support_options'" do
    context "with some sectors, a stage, a structure, types and location specified" do
      before :each do
        Scheme.stub(:lookup).and_return([])
      end

      def do_get
        get :support_options, :sectors => "health_manufacturing", :stages => "start-up", :structures => "partnership", :types => 'finance_equity', :locations => 'wales'
      end

      it "returns http success" do
        do_get
        response.should be_success
      end

      it "should set correct expiry headers" do
        do_get

        response.headers["Cache-Control"].should == "max-age=1800, public"
      end

      it "loads the given sectors and assigns them to @sector_filters" do
        Sector.should_receive(:find_by_slugs).with(%w(health manufacturing)).and_return(:some_sectors)
        do_get
        assigns[:sector_filters].should == :some_sectors
      end

      it "loads the given stages and assigns them to @stage_filters" do
        Stage.should_receive(:find_by_slugs).with(%w(start-up)).and_return(:some_stages)
        do_get
        assigns[:stage_filters].should == :some_stages
      end

      it "loads the given structures and assigns them to @structure_filters" do
        Structure.should_receive(:find_by_slugs).with(%w(partnership)).and_return(:some_structures)
        do_get
        assigns[:structure_filters].should == :some_structures
      end

      it "loads the given types and assigns them to @type_filters" do
        Type.should_receive(:find_by_slugs).with(%w(finance equity)).and_return(:some_types)
        do_get
        assigns[:type_filters].should == :some_types
      end

      it "loads the given locations and assigns them to @location_filters" do
        Location.should_receive(:find_by_slugs).with(%w(wales)).and_return(:some_locations)
        do_get
        assigns[:location_filters].should == :some_locations
      end

      it "looks up the available support schemes, and assigns them to @support_options" do
        Sector.stub(:find_by_slugs).and_return(:some_sectors)
        Stage.stub(:find_by_slugs).and_return(:some_stages)
        Structure.stub(:find_by_slugs).and_return(:some_structures)
        Type.stub(:find_by_slugs).and_return(:some_types)
        Location.stub(:find_by_slugs).and_return(:some_locations)

        Scheme.should_receive(:lookup).
          with(:sectors => :some_sectors, :stages => :some_stages, :structures => :some_structures, :types => :some_types, :locations => :some_locations).
          and_return(:some_schemes)

        do_get
        assigns[:support_options].should == :some_schemes
      end
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

    it "should set the slimmer format header" do
      get :index

      response.headers["#{Slimmer::Headers::HEADER_PREFIX}-Format"].should == "finder"
    end
  end
end
