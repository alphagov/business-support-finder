require 'spec_helper'

describe "Finding support options" do

  before do
    stub_imminence_business_support_schemes_for_filter(
      nil,
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
  end

  before do
    visit "/#{APP_SLUG}/search"
  end

  it "should show all available schemes by default" do
    page.should have_selector('.filter-results-summary h3 span', text: '2')
    page.should have_content 'Graduate start-up scheme'
    page.should have_content 'Manufacturing Services scheme - Wales'
  end

  it "should allow filtering"
end
