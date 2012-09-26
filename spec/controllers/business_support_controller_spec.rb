require 'spec_helper'

describe BusinessSupportController do
  before :each do
    @question1 = "What is your activity or business?"
    @question2 = "What stage is your business at?"
    @question3 = "How is your business structured?"
    @question4 = "Where will you be located?"
  end

  describe "GET 'start'" do
    it "returns http success" do
      get 'start'
      response.should be_success
    end
  end

  describe "GET 'sectors'" do
    it "returns http success" do
      get :sectors
      response.should be_success
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
      assigns[:upcoming_questions].should == [@question2, @question3, @question4]
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
        assigns[:upcoming_questions].should == [@question3, @question4]
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
        it "should redirect to the structure page, passing through necessary params" do
          post :stage_submit, :sectors => "health_manufacturing", :stage => "pre-startup"
          response.should redirect_to(structure_path(:sectors => "health_manufacturing", :stage => "pre-startup"))
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
      post :stage_submit, :stage => "pre-startup"
      response.should be_not_found
    end

    it "should 404 with no valid sectors specified" do
      post :stage_submit, :sectors => "non-existent", :stage => "pre-startup"
      response.should be_not_found
    end
  end

  describe "GET 'structure'" do
    context "with some sectors specified and a stage" do
      def do_get
        get :structure, :sectors => "health_manufacturing", :stage => "start-up"
      end

      it "returns http success" do
        do_get
        response.should be_success
      end

      it "assigns all the business structures" do
        Structure.should_receive(:all).and_return(:some_structures)
        do_get
        assigns[:structures].should == :some_structures
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
        assigns[:upcoming_questions].should == [@question4]
      end
    end

    it "should 404 with no sectors specified" do
      get :structure, :stage => "start-up"
      response.should be_not_found
    end

    it "should 404 with no valid sectors specified" do
      get :structure, :sectors => "non-existent", :stage => "start-up"
      response.should be_not_found
    end

    it "should 404 with an invalid stage" do
      get :structure, :sectors => "health_manufacturing", :stage => "non-existent"
      response.should be_not_found
    end

    it "should 404 with no stage specified" do
      get :structure, :sectors => "health_manufacturing"
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

    it "should set the slimmer format header" do
      get :index

      response.headers["#{Slimmer::Headers::HEADER_PREFIX}-Format"].should == "business-support-finder"
    end
  end
end
