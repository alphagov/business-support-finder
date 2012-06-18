require "spec_helper"

describe BusinessSupport do
  it "should use the correct field types on the model" do
    BusinessSupport.safely.create!(
      title: "Example Business Support Title",
      description: "Example business support description",
      business_stages: %w(Pre-startup Startup),
      business_types: ["Private Company", "Partnership"],
      purposes: ["Business growth and expansion", "Consultancy and business advice"],
      support_types: %w(Award Consultancy),
      business_sectors: ["Agriculture", "Business and Finance"],
    )
    support = BusinessSupport.first
    support.title.should == "Example Business Support Title"
    support.description.should == "Example business support description"
    support.business_stages.should == %w(Pre-startup Startup)
    support.business_types.should == ["Private Company", "Partnership"]
    support.purposes.should == ["Business growth and expansion", "Consultancy and business advice"]
    support.support_types.should == %w(Award Consultancy)
    support.business_sectors.should == ["Agriculture", "Business and Finance"]
  end

  describe "validations" do
    before :each do
      @support = FactoryGirl.build(:business_support)
    end

    it "should require a title" do
      @support.title = ''
      @support.should_not be_valid
    end

    it "should require a description" do
      @support.description = ''
      @support.should_not be_valid
    end

    it "should require business_stages to be one of the allowed values" do
      @support.business_stages = ["Invalid stage"]
      @support.should_not be_valid
    end

    it "should require business_types to be one of the allowed values" do
      @support.business_types = ["Invalid type"]
      @support.should_not be_valid
    end

    it "should require purposes to be one of the allowed values" do
      @support.purposes = ["Invalid purpose"]
      @support.should_not be_valid
    end

    it "should require support_types to be one of the allowed values" do
      @support.support_types = ["Invalid support type"]
      @support.should_not be_valid
    end

    it "should require business_sectors to be one of the allowed values" do
      @support.business_sectors = ["Invalid business sector"]
      @support.should_not be_valid
    end
  end
end
