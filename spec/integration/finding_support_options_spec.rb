require 'spec_helper'

describe "Finding support options" do

  specify "Happy path through the app" do
    imminence_has_business_support_schemes(
      {
        "sectors" => "education,hospitality-and-catering",
        "stages" => "start-up",
        "business_types" => "public-limited-company",
        "locations" => "wales",
        "types" => "finance,grant,loan,equity"
      },
      [
        {"title" => "Graduate start-up", "business_support_identifier" => "graduate-start-up"},
        {"title" => "Manufacturing Services - Wales", "business_support_identifier" => "manufacturing-services-wales"},
      ]
    )
    content_api_has_business_support_scheme(
      "title" => "Graduate start-up scheme",
      "web_url" => "https://www.gov.uk/graduate-start-up",
      "details" => {
        "business_support_identifier" => "graduate-start-up",
        "short_description" => "Some blurb abour the Graduate start-up scheme",
      }
    )
    content_api_has_business_support_scheme(
      "title" => "Manufacturing Services scheme - Wales",
      "web_url" => "https://www.gov.uk/wales/manufacturing-services-scheme",
      "details" => {
        "business_support_identifier" => "manufacturing-services-wales",
        "short_description" => "Some blurb abour the welsh Manufacturing services scheme",
      }
    )

    visit "/#{APP_SLUG}"

    page.should have_link("Get started")

    click_on "Get started"

    i_should_be_on "/#{APP_SLUG}/sectors"

    within '.current-question' do
      page.should have_content("What is your activity or business?")
    end

    click_add_link "Education"
    click_add_link "Hospitality and Catering"

    click_on "Next step"

    i_should_be_on "/#{APP_SLUG}/stage", :ignore_query => true

    within_section 'completed question 1' do
      page.should have_content("Education")
      page.should have_content("Hospitality and Catering")
    end

    within '.current-question' do
      page.should have_content("What stage is your business at?")

      select 'Start-up', :from => 'Select a stage'

      click_on 'Next step'
    end

    i_should_be_on "/#{APP_SLUG}/structure", :ignore_query => true

    within_section 'completed question 1' do
      page.should have_content("Education")
      page.should have_content("Hospitality and Catering")
    end
    within_section 'completed question 2' do
      page.should have_content("Start-up")
    end

    within '.current-question' do
      page.should have_content("How is your business structured?")

      select 'Public limited company', :from => "Select a structure"
      click_on 'Next step'
    end

    i_should_be_on "/#{APP_SLUG}/types", :ignore_query => true

    within_section 'completed question 1' do
      page.should have_content("Education")
      page.should have_content("Hospitality and Catering")
    end
    within_section 'completed question 2' do
      page.should have_content("Start-up")
    end
    within_section 'completed question 3' do
      page.should have_content("Public limited company")
    end

    within '.current-question' do
      page.should have_content("What type of support are you interested in?")

      select 'Finance, grants and loans', :from => "Select a type of business support"
      click_on 'Next step'
    end

    i_should_be_on "/#{APP_SLUG}/location", :ignore_query => true

    within_section 'completed question 1' do
      page.should have_content("Education")
      page.should have_content("Hospitality and Catering")
    end
    within_section 'completed question 2' do
      page.should have_content("Start-up")
    end
    within_section 'completed question 3' do
      page.should have_content("Public limited company")
    end
    within_section 'completed question 4' do
      page.should have_content("Finance, grants and loans")
    end

    within '.current-question' do
      page.should have_content("Where is your business located?")

      select 'Wales', :from => "Select a location"
      click_on 'Find support'
    end

    i_should_be_on "/#{APP_SLUG}/support-options", :ignore_query => true

    within '.results' do
      page.should have_content("Available support")

      page.all("li a").map(&:text).should == ["Graduate start-up scheme", "Manufacturing Services scheme - Wales"]
    end
  end
end
