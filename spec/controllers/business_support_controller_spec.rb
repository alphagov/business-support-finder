require 'spec_helper'

describe BusinessSupportController do
  before :each do
    @question1 = "What is your activity or business?"
    @question2 = "What stage is your business at?"
    @question3 = "How many employees do you have?"
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

  describe "GET 'sectors'" do
    it "returns http success" do
      get :sectors
      response.should be_success
    end

    it "should set correct expiry headers" do
      get :sectors

      response.headers["Cache-Control"].should == "max-age=1800, public"
    end

    it "should assign all sectors" do
      sector = Sector.new(:slug => 'something', :name => 'Something')
      Sector.should_receive(:all).and_return([sector])
      get :sectors

      assigns[:sectors].should == [sector]
    end

    it "sets up the questions correctly" do
      get :sectors
      assigns[:current_question_number].should == 1
      assigns[:completed_questions].should == []
      assigns[:current_question].should == @question1
      assigns[:upcoming_questions].should == [@question2, @question3, @question4, @question5]
    end

    describe "assigning picked sectors" do
      it "should assign picked sectors if some given" do
        Sector.should_receive(:find_by_slugs).with(["alpha", "bravo"]).and_return(:the_picked_sectors)
        get :sectors, :sectors => "alpha_bravo"

        assigns[:picked_sectors].should == :the_picked_sectors
      end

      it "should assign empty array if no sectors given" do
        get :sectors, :sectors => ""

        assigns[:picked_sectors].should == []
      end
    end
  end

  describe "GET 'stage'" do
    context "with some sectors specified" do
      def do_get
        get :stage, :sectors => "health_manufacturing"
      end

      it "returns http success" do
        do_get
        response.should be_success
      end

      it "should set correct expiry headers" do
        do_get

        response.headers["Cache-Control"].should == "max-age=1800, public"
      end

      it "assigns all the business stages" do
        Stage.should_receive(:all).and_return(:some_stages)
        do_get
        assigns[:stages].should == :some_stages
      end

      it "loads the given sectors and assigns them to @sectors" do
        Sector.should_receive(:find_by_slugs).with(%w(health manufacturing)).and_return(:some_sectors)
        do_get
        assigns[:sectors].should == :some_sectors
      end

      it "sets up the questions correctly" do
        Sector.stub(:find_by_slugs).and_return(:some_sectors)
        do_get
        assigns[:current_question_number].should == 2
        assigns[:completed_questions].should == [[@question1, :some_sectors, 'sectors']]
        assigns[:current_question].should == @question2
        assigns[:upcoming_questions].should == [@question3, @question4, @question5]
      end
    end

    it "should 404 with no sectors specified" do
      get :stage
      response.should be_not_found
    end

    it "should 404 with no valid sectors specified" do
      get :stage, :sectors => "non-existent"
      response.should be_not_found
    end
  end

  describe "POST 'stage_submit'" do
    context "with valid sectors" do
      context "with a valid stage" do
        it "should redirect to the size page, passing through necessary params" do
          post :stage_submit, :sectors => "health_manufacturing", :stage => "pre-start"
          response.should redirect_to(size_path(:sectors => "health_manufacturing", :stage => "pre-start"))
        end
      end

      context "with an invalid stage" do
        it "should redirect back to the form preserving the sectors" do
          post :stage_submit, :sectors => "health_manufacturing", :stage => "non-existent"
          response.should redirect_to(stage_path(:sectors => "health_manufacturing"))
        end
      end

      context "with no stage" do
        it "should redirect back to the form preserving the sectors" do
          post :stage_submit, :sectors => "health_manufacturing"
          response.should redirect_to(stage_path(:sectors => "health_manufacturing"))
        end
      end
    end

    it "should 404 with no sectors specified" do
      post :stage_submit, :stage => "pre-start"
      response.should be_not_found
    end

    it "should 404 with no valid sectors specified" do
      post :stage_submit, :sectors => "non-existent", :stage => "pre-start"
      response.should be_not_found
    end
  end

  describe "GET 'size'" do
    context "with some sectors specified and a stage" do
      def do_get
        get :size, :sectors => "health_manufacturing", :stage => "start-up"
      end

      it "returns http success" do
        do_get
        response.should be_success
      end

      it "should set correct expiry headers" do
        do_get

        response.headers["Cache-Control"].should == "max-age=1800, public"
      end

      it "assigns all the business sizes" do
        Size.should_receive(:all).and_return(:some_sizes)
        do_get
        assigns[:sizes].should == :some_sizes
      end

      it "loads the given sectors and assigns them to @sectors" do
        Sector.should_receive(:find_by_slugs).with(%w(health manufacturing)).and_return(:some_sectors)
        do_get
        assigns[:sectors].should == :some_sectors
      end

      it "loads the given stage and assigns it to @stage" do
        Stage.should_receive(:find_by_slug).with('start-up').and_return(:a_stage)
        do_get
        assigns[:stage].should == :a_stage
      end

      it "sets up the questions correctly" do
        Sector.stub(:find_by_slugs).and_return(:some_sectors)
        Stage.stub(:find_by_slug).and_return(:a_stage)
        do_get
        assigns[:current_question_number].should == 3
        assigns[:completed_questions].should == [
          [@question1, :some_sectors, 'sectors'],
          [@question2, [:a_stage], 'stage'],
        ]
        assigns[:current_question].should == @question3
        assigns[:upcoming_questions].should == [@question4, @question5]
      end
    end

    it "should 404 with no sectors specified" do
      get :size, :stage => "start-up"
      response.should be_not_found
    end

    it "should 404 with no valid sectors specified" do
      get :size, :sectors => "non-existent", :stage => "start-up"
      response.should be_not_found
    end

    it "should 404 with an invalid stage" do
      get :size, :sectors => "health_manufacturing", :stage => "non-existent"
      response.should be_not_found
    end

    it "should 404 with no stage specified" do
      get :size, :sectors => "health_manufacturing"
      response.should be_not_found
    end
  end

  describe "POST 'size_submit'" do
    context "with valid sectors, and stage" do
      context "with a valid size" do
        it "should redirect to the types page, passing through necessary params" do
          post :size_submit, :sectors => "health_manufacturing", :stage => "pre-start", :size => "under-10"
          response.should redirect_to(types_path(:sectors => "health_manufacturing", :stage => "pre-start", :size => "under-10"))
        end
      end

      context "with an invalid size" do
        it "should redirect back to the form preserving the sectors and stage" do
          post :size_submit, :sectors => "health_manufacturing", :stage => "pre-start", :size => "non-existent"
          response.should redirect_to(size_path(:sectors => "health_manufacturing", :stage => "pre-start"))
        end
      end

      context "with no size" do
        it "should redirect back to the form preserving the sectors and stage" do
          post :size_submit, :sectors => "health_manufacturing", :stage => "pre-start"
          response.should redirect_to(size_path(:sectors => "health_manufacturing", :stage => "pre-start"))
        end
      end
    end

    it "should 404 with no sectors specified" do
      post :size_submit, :stage => "start-up", :size => 'under-10'
      response.should be_not_found
    end

    it "should 404 with no valid sectors specified" do
      post :size_submit, :sectors => "non-existent", :stage => "start-up", :size => 'under-10'
      response.should be_not_found
    end

    it "should 404 with an invalid stage" do
      post :size_submit, :sectors => "health_manufacturing", :stage => "non-existent", :size => 'under-10'
      response.should be_not_found
    end

    it "should 404 with no stage specified" do
      post :size_submit, :sectors => "health_manufacturing", :size => 'under-10'
      response.should be_not_found
    end
  end

  describe "GET 'types'" do
    context "with some sectors, a stage and a size specified" do
      def do_get(attrs = {})
        get :types, {:sectors => "health_manufacturing", :stage => "start-up", :size => "under-10"}.merge(attrs)
      end

      it "returns http success" do
        do_get
        response.should be_success
      end

      it "should set correct expiry headers" do
        do_get

        response.headers["Cache-Control"].should == "max-age=1800, public"
      end

      it "assigns all the support types" do
        Type.should_receive(:all).and_return(:some_types)
        do_get
        assigns[:types].should == :some_types
      end

      it "loads the given sectors and assigns them to @sectors" do
        Sector.should_receive(:find_by_slugs).with(%w(health manufacturing)).and_return(:some_sectors)
        do_get
        assigns[:sectors].should == :some_sectors
      end

      it "loads the given stage and assigns it to @stage" do
        Stage.should_receive(:find_by_slug).with('start-up').and_return(:a_stage)
        do_get
        assigns[:stage].should == :a_stage
      end

      it "loads the given size and assigns it to @size" do
        Size.should_receive(:find_by_slug).with('under-10').and_return(:a_size)
        do_get
        assigns[:size].should == :a_size
      end

      it "sets up the questions correctly" do
        Sector.stub(:find_by_slugs).and_return(:some_sectors)
        Stage.stub(:find_by_slug).and_return(:a_stage)
        Size.stub(:find_by_slug).and_return(:a_size)
        do_get
        assigns[:current_question_number].should == 4
        assigns[:completed_questions].should == [
          [@question1, :some_sectors, 'sectors'],
          [@question2, [:a_stage], 'stage'],
          [@question3, [:a_size], 'size'],
        ]
        assigns[:current_question].should == @question4
        assigns[:upcoming_questions].should == [@question5]
      end

      context "with some pre-selected types" do
        it "should assign the picked types" do
          Type.should_receive(:find_by_slugs).with(%w(finance grant)).and_return(:some_picked_types)
          do_get(:types => "finance_grant")
          assigns[:picked_types].should == :some_picked_types
        end
      end
    end

    it "should 404 with no sectors specified" do
      get :location, :stage => "start-up", :size => 'under-10'
      response.should be_not_found
    end

    it "should 404 with no valid sectors specified" do
      get :location, :sectors => "non-existent", :stage => "start-up", :size => 'under-10'
      response.should be_not_found
    end

    it "should 404 with an invalid stage" do
      get :location, :sectors => "health_manufacturing", :stage => "non-existent", :size => 'under-10'
      response.should be_not_found
    end

    it "should 404 with no stage specified" do
      get :location, :sectors => "health_manufacturing", :size => 'under-10'
      response.should be_not_found
    end

    it "should 404 with an invalid size" do
      get :location, :sectors => "health_manufacturing", :stage => "start-up", :size => 'non-existent'
      response.should be_not_found
    end

    it "should 404 with no size specified" do
      get :location, :sectors => "health_manufacturing", :stage => 'start-up'
      response.should be_not_found
    end
  end

  describe "POST 'types_submit'" do
    context "with valid size, sectors, and stage" do
      context "with valid types" do
        it "should redirect to the location page, passing through necessary params" do
          post :types_submit, :sectors => "health_manufacturing", :stage => "pre-start", :size => "under-10", :types => ["finance", "grant"]
          response.should redirect_to(location_path(:sectors => "health_manufacturing", :stage => "pre-start", :size => "under-10", :types => "finance_grant"))
        end
      end

      context "with no valid types" do
        it "should redirect back to the form preserving the size, sectors and stage" do
          post :types_submit, :sectors => "health_manufacturing", :stage => "pre-start", :size => "under-10", :types => ["non-existent"]
          response.should redirect_to(types_path(:sectors => "health_manufacturing", :stage => "pre-start", :size => "under-10"))
        end
      end

      context "with no types" do
        it "should redirect back to the form preserving the size, sectors and stage" do
          post :types_submit, :sectors => "health_manufacturing", :stage => "pre-start", :size => "under-10"
          response.should redirect_to(types_path(:sectors => "health_manufacturing", :stage => "pre-start", :size => "under-10"))
        end
      end
    end

    it "should 404 with no sectors specified" do
      post :types_submit, :stage => "start-up", :size => 'under-10', :types => 'finance'
      response.should be_not_found
    end

    it "should 404 with no valid sectors specified" do
      post :types_submit, :sectors => "non-existent", :stage => "start-up", :size => 'under-10', :types => 'finance'
      response.should be_not_found
    end

    it "should 404 with an invalid stage" do
      post :types_submit, :sectors => "health_manufacturing", :stage => "non-existent", :size => 'under-10', :types => 'finance'
      response.should be_not_found
    end

    it "should 404 with no stage specified" do
      post :types_submit, :sectors => "health_manufacturing", :size => 'under-10', :types => 'finance'
      response.should be_not_found
    end

    it "should 404 with an invalid size" do
      post :types_submit, :sectors => "health_manufacturing", :stage => "start-up", :size => 'non-existent', :types => 'finance'
      response.should be_not_found
    end

    it "should 404 with no size specified" do
      post :types_submit, :sectors => "health_manufacturing", :stage => 'start-up', :types => 'finance'
      response.should be_not_found
    end
  end

  describe "GET 'location'" do
    context "with some sectors, a stage, a size and a type specified" do
      def do_get
        get :location, :sectors => "health_manufacturing", :stage => "start-up", :size => "under-10", :types => "finance_grant"
      end

      it "returns http success" do
        do_get
        response.should be_success
      end

      it "should set correct expiry headers" do
        do_get

        response.headers["Cache-Control"].should == "max-age=1800, public"
      end

      it "assigns all the business locations" do
        Location.should_receive(:all).and_return(:some_locations)
        do_get
        assigns[:locations].should == :some_locations
      end

      it "loads the given sectors and assigns them to @sectors" do
        Sector.should_receive(:find_by_slugs).with(%w(health manufacturing)).and_return(:some_sectors)
        do_get
        assigns[:sectors].should == :some_sectors
      end

      it "loads the given stage and assigns it to @stage" do
        Stage.should_receive(:find_by_slug).with('start-up').and_return(:a_stage)
        do_get
        assigns[:stage].should == :a_stage
      end

      it "loads the given size and assigns it to @size" do
        Size.should_receive(:find_by_slug).with('under-10').and_return(:a_size)
        do_get
        assigns[:size].should == :a_size
      end

      it "loads the given types and assigns them to @types" do
        Type.should_receive(:find_by_slugs).with(%w(finance grant)).and_return(:some_types)
        do_get
        assigns[:types].should == :some_types
      end

      it "sets up the questions correctly" do
        Sector.stub(:find_by_slugs).and_return(:some_sectors)
        Stage.stub(:find_by_slug).and_return(:a_stage)
        Size.stub(:find_by_slug).and_return(:a_size)
        Type.stub(:find_by_slugs).and_return(:some_types)
        do_get
        assigns[:current_question_number].should == 5
        assigns[:completed_questions].should == [
          [@question1, :some_sectors, 'sectors'],
          [@question2, [:a_stage], 'stage'],
          [@question3, [:a_size], 'size'],
          [@question4, :some_types, 'types'],
        ]
        assigns[:current_question].should == @question5
        assigns[:upcoming_questions].should == []
      end
    end

    it "should 404 with no sectors specified" do
      get :location, :stage => "start-up", :size => 'under-10', :types => 'finance'
      response.should be_not_found
    end

    it "should 404 with no valid sectors specified" do
      get :location, :sectors => "non-existent", :stage => "start-up", :size => 'under-10', :types => 'finance'
      response.should be_not_found
    end

    it "should 404 with an invalid stage" do
      get :location, :sectors => "health_manufacturing", :stage => "non-existent", :size => 'under-10', :types => 'finance'
      response.should be_not_found
    end

    it "should 404 with no stage specified" do
      get :location, :sectors => "health_manufacturing", :size => 'under-10', :types => 'finance'
      response.should be_not_found
    end

    it "should 404 with an invalid size" do
      get :location, :sectors => "health_manufacturing", :stage => "start-up", :size => 'non-existent', :types => 'finance'
      response.should be_not_found
    end

    it "should 404 with no size specified" do
      get :location, :sectors => "health_manufacturing", :stage => 'start-up', :types => 'finance'
      response.should be_not_found
    end

    it "should 404 with no valid types" do
      get :location, :sectors => "health_manufacturing", :stage => "start-up", :size => 'under-10', :types => 'non-existent'
      response.should be_not_found
    end

    it "should 404 with no types specified" do
      get :location, :sectors => "health_manufacturing", :stage => 'start-up', :size => 'under-10'
      response.should be_not_found
    end
  end

  describe "POST 'location_submit'" do
    context "with valid sectors, stage, size and types" do
      context "with a valid location" do
        it "should redirect to the support options page, passing through necessary params" do
          post :location_submit, :sectors => "health_manufacturing", :stage => "pre-start", :size => "under-10", :types => 'finance', :location => 'england'
          response.should redirect_to(support_options_path(:sectors => "health_manufacturing", :stage => "pre-start", :size => "under-10", :types => 'finance', :location => 'england'))
        end
      end

      context "with an invalid location" do
        it "should redirect back to the form preserving the sectors and stage" do
          post :location_submit, :sectors => "health_manufacturing", :stage => "pre-start", :size => "under-10", :types => 'finance', :location => "non-existent"
          response.should redirect_to(location_path(:sectors => "health_manufacturing", :stage => "pre-start", :types => 'finance', :size => "under-10"))
        end
      end

      context "with no location" do
        it "should redirect back to the form preserving the sectors and stage" do
          post :location_submit, :sectors => "health_manufacturing", :stage => "pre-start", :size => "under-10", :types => 'finance'
          response.should redirect_to(location_path(:sectors => "health_manufacturing", :stage => "pre-start", :size => "under-10", :types => 'finance'))
        end
      end
    end

    it "should 404 with no sectors specified" do
      post :location_submit, :stage => "start-up", :size => 'under-10', :types => 'finance', :location => 'england'
      response.should be_not_found
    end

    it "should 404 with no valid sectors specified" do
      post :location_submit, :sectors => "non-existent", :stage => "start-up", :size => 'under-10', :types => 'finance', :location => 'england'
      response.should be_not_found
    end

    it "should 404 with an invalid stage" do
      post :location_submit, :sectors => "health_manufacturing", :stage => "non-existent", :size => 'under-10', :types => 'finance', :location => 'england'
      response.should be_not_found
    end

    it "should 404 with no stage specified" do
      post :location_submit, :sectors => "health_manufacturing", :size => 'under-10', :types => 'finance', :location => 'england'
      response.should be_not_found
    end

    it "should 404 with an invalid size" do
      post :location_submit, :sectors => "health_manufacturing", :stage => "start-up", :size => 'non-existent', :types => 'finance', :location => 'england'
      response.should be_not_found
    end

    it "should 404 with no size specified" do
      post :location_submit, :sectors => "health_manufacturing", :stage => 'start-up', :types => 'finance', :location => 'england'
      response.should be_not_found
    end

    it "should 404 with no valid types" do
      post :location_submit, :sectors => "health_manufacturing", :stage => "start-up", :size => 'under-10', :types => 'non-existent', :location => 'england'
      response.should be_not_found
    end

    it "should 404 with no types specified" do
      post :location_submit, :sectors => "health_manufacturing", :stage => 'start-up', :size => 'under-10', :location => 'england'
      response.should be_not_found
    end
  end

  describe "GET 'support_options'" do
    context "with some sectors, a stage, a size, types and location specified" do
      before :each do
        Scheme.stub(:lookup).and_return([])
      end

      def do_get
        get :support_options, :sectors => "health_manufacturing", :stage => "start-up", :size => "under-10", :types => 'finance_equity', :location => 'wales'
      end

      it "returns http success" do
        do_get
        response.should be_success
      end

      it "should set correct expiry headers" do
        do_get

        response.headers["Cache-Control"].should == "max-age=1800, public"
      end

      it "loads the given sectors and assigns them to @sectors" do
        Sector.should_receive(:find_by_slugs).with(%w(health manufacturing)).and_return(:some_sectors)
        do_get
        assigns[:sectors].should == :some_sectors
      end

      it "loads the given stage and assigns it to @stage" do
        Stage.should_receive(:find_by_slug).with('start-up').and_return(:a_stage)
        do_get
        assigns[:stage].should == :a_stage
      end

      it "loads the given size and assigns it to @size" do
        Size.should_receive(:find_by_slug).with('under-10').and_return(:a_size)
        do_get
        assigns[:size].should == :a_size
      end

      it "loads the given types and assigns them to @types" do
        Type.should_receive(:find_by_slugs).with(%w(finance equity)).and_return(:some_types)
        do_get
        assigns[:types].should == :some_types
      end

      it "loads the given location and assigns it to @location" do
        Location.should_receive(:find_by_slug).with('wales').and_return(:a_location)
        do_get
        assigns[:location].should == :a_location
      end

      it "sets up the questions correctly" do
        Sector.stub(:find_by_slugs).and_return(:some_sectors)
        Stage.stub(:find_by_slug).and_return(:a_stage)
        Size.stub(:find_by_slug).and_return(:a_size)
        Type.stub(:find_by_slugs).and_return(:some_types)
        Location.stub(:find_by_slug).and_return(:a_location)
        do_get
        assigns[:completed_questions].should == [
          [@question1, :some_sectors, 'sectors'],
          [@question2, [:a_stage], 'stage'],
          [@question3, [:a_size], 'size'],
          [@question4, :some_types, 'types'],
          [@question5, [:a_location], 'location'],
        ]
      end

      it "looks up the available support schemes, and assigns them to @support_options" do
        Sector.stub(:find_by_slugs).and_return(:some_sectors)
        Stage.stub(:find_by_slug).and_return(:a_stage)
        Size.stub(:find_by_slug).and_return(:a_size)
        Type.stub(:find_by_slugs).and_return(:some_types)
        Location.stub(:find_by_slug).and_return(:a_location)

        Scheme.should_receive(:lookup).
          with(:sectors => :some_sectors, :stage => :a_stage, :size => :a_size, :types => :some_types, :location => :a_location).
          and_return(:some_schemes)

        do_get
        assigns[:support_options].should == :some_schemes
      end

      it "should 503 if the API call times out" do
        Scheme.stub(:lookup).and_raise(GdsApi::TimedOutException)

        do_get
        response.status.should == 503
      end
    end

    it "should 404 with no sectors specified" do
      get :support_options, :stage => "start-up", :size => 'under-10', :types => 'finance', :location => 'wales'
      response.should be_not_found
    end

    it "should 404 with no valid sectors specified" do
      get :support_options, :sectors => "non-existent", :stage => "start-up", :size => 'under-10', :types => 'finance', :location => 'wales'
      response.should be_not_found
    end

    it "should 404 with an invalid stage" do
      get :support_options, :sectors => "health_manufacturing", :stage => "non-existent", :size => 'under-10', :types => 'finance', :location => 'wales'
      response.should be_not_found
    end

    it "should 404 with no stage specified" do
      get :support_options, :sectors => "health_manufacturing", :size=> 'under-10', :types => 'finance', :location => 'wales'
      response.should be_not_found
    end

    it "should 404 with an invalid size" do
      get :support_options, :sectors => "health_manufacturing", :stage => "start-up", :size => 'non-existent', :types => 'finance', :location => 'wales'
      response.should be_not_found
    end

    it "should 404 with no size specified" do
      get :support_options, :sectors => "health_manufacturing", :stage => 'start-up', :types => 'finance', :location => 'wales'
      response.should be_not_found
    end

    it "should 404 with no valid types" do
      get :support_options, :sectors => "health_manufacturing", :stage => "start-up", :size => 'under-10', :types => 'non-existent', :location => 'wales'
      response.should be_not_found
    end

    it "should 404 with no type specified" do
      get :support_options, :sectors => "health_manufacturing", :stage => 'start-up', :size => 'under-10', :location => 'wales'
      response.should be_not_found
    end

    it "should 404 with an invalid location" do
      get :support_options, :sectors => "health_manufacturing", :stage => "start-up", :size => 'under-10', :types => 'finance', :location => 'non-existent'
      response.should be_not_found
    end

    it "should 404 with no location specified" do
      get :support_options, :sectors => "health_manufacturing", :stage => 'start-up', :size => 'under-10', :types => 'finance'
      response.should be_not_found
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
