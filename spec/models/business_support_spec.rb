require "spec_helper"

describe BusinessSupport do
  it "should use the correct field types on the model" do
    BusinessSupport.safely.create!(
      title: "Example Business Support Title",
      description: "Example business support description",
      business_stages: %w(Pre-startup Start-up),
      business_types: ["Private company", "Partnership"],
      purposes: ["Business growth and expansion", "Consultancy and business advice"],
      support_types: %w(Award Consultancy),
      business_sectors: ["Agriculture", "Business and finance"],
      website_url: "www.espritcp.com/about",
      contact_details: "Contact details",
      organiser: "Super organiser",
      min_turnover: 100,
      max_turnover: 200,
      min_grant_value: 100,
      max_grant_value: 200,
      min_age: 4,
      max_age: 10,
      min_employees: 10,
      max_employees: 20
    )
    support = BusinessSupport.first
    support.title.should == "Example Business Support Title"
    support.description.should == "Example business support description"
    support.business_stages.should == %w(Pre-startup Start-up)
    support.business_types.should == ["Private company", "Partnership"]
    support.purposes.should == ["Business growth and expansion", "Consultancy and business advice"]
    support.support_types.should == %w(Award Consultancy)
    support.business_sectors.should == ["Agriculture", "Business and finance"]
    support.website_url == "www.espritcp.com/about"
    support.contact_details == "Contact details"
    support.organiser == "Super organiser"
    support.min_turnover == 100
    support.max_turnover == 200
    support.min_grant_value == 100
    support.max_grant_value == 200
    support.min_age == 4
    support.max_age == 10
    support.min_employees == 10
    support.max_employees == 20
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

    it "should require min_turnover to be less than max_turnover if they both exist" do
      @support.min_turnover = 200
      @support.max_turnover = 100
      @support.should_not be_valid
    end

    it "should require min_grant_value to be less than max_grant_value if they both exist" do
      @support.min_grant_value = 200
      @support.max_grant_value = 100
      @support.should_not be_valid
    end

    it "should require min_age to be less than max_age if they both exist" do
      @support.min_age = 200
      @support.max_age = 100
      @support.should_not be_valid
    end

    it "should require min_employees to be less max_employees if they both exist" do
      @support.min_employees = 200
      @support.max_employees = 100
      @support.should_not be_valid
    end
  end
end
