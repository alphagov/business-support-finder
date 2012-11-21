require 'spec_helper'

describe "Finding support options" do

  specify "Happy path through the app" do
    imminence_has_business_support_schemes(
      {
        "sectors" => "education,hospitality-and-catering",
        "stages" => "start-up",
        "business_types" => "public-limited-company",
        "locations" => "wales",
        "types" => "finance,grant,loan"
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

    i_should_be_on "/#{APP_SLUG}/support-options"

    check "Education"
    check "Hospitality and Catering"

    check "Finance (any)"
    check "Grant"
    check "Loan"

    check "Wales"

    click_on "Filter"

    i_should_be_on "/#{APP_SLUG}/support-options?locations=wales&sectors=education_hospitality-and-catering&types=finance_grant_loan"

#    within '.results' do
      #page.should have_content("Available support")

      #page.all("li a").map(&:text).should == ["Graduate start-up scheme", "Manufacturing Services scheme - Wales"]
    #end
  end
end
