require 'spec_helper'

describe "Finding support options" do

  before do
    imminence_has_business_support_schemes(
      nil,
      [
        {"title" => "Graduate start-up", "business_support_identifier" => "graduate-start-up"},
        {"title" => "Manufacturing Services - Wales", "business_support_identifier" => "manufacturing-services-wales"},
      ]
    )
    imminence_has_business_support_schemes(
      {
            "support_types" => "finance,equity,grant,loan,expertise-and-advice,recognition-award",
      },
      [
        {"title" => "Graduate start-up", "business_support_identifier" => "graduate-start-up"},
        {"title" => "Manufacturing Services - Wales", "business_support_identifier" => "manufacturing-services-wales"},
      ]
    )
    imminence_has_business_support_schemes(
      {
            "stages" => "grow-and-sustain",
            "business_sizes" => "up-to-249",
            "sectors" => "education",
            "locations" => "london",
            "support_types" => "finance,equity,grant,expertise-and-advice",
      },
      [
        {"title" => "Graduate start-up", "business_support_identifier" => "graduate-start-up"},
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
    page.should have_content 'Graduate start-up scheme'
    page.should have_content 'Manufacturing Services scheme - Wales'
    page.assert_selector('li.scheme', count: 2)
    page.should have_selector('.filter-results-summary h3 span', text: '2') # result count
  end

  it "should show all available schemes if nothing selected" do
    click_on "Refresh results"
    page.should have_content 'Graduate start-up scheme'
    page.should have_content 'Manufacturing Services scheme - Wales'
    page.assert_selector('li.scheme', count: 2)
    page.should have_selector('.filter-results-summary h3 span', text: '2') # result count
  end

  it "should allow filtering" do
    uncheck("loan")
    uncheck("recognition-award")
    select "London", :from => "location"
    select "249", :from => "size"
    select "Education", :from => "sector"
    select "Grow", :from => "stage"
    click_on "Refresh results"
    page.assert_selector('li.scheme', count: 1)
    page.should have_content 'Graduate start-up scheme'
    page.should have_selector('.filter-results-summary h3 span', text: '1') # result count
  end

  it "should show 'no matching' if none checked" do
    uncheck("recognition-award")
    uncheck("finance")
    uncheck("equity")
    uncheck("loan")
    uncheck("expertise-and-advice")
    uncheck("grant")
    click_on "Refresh results"
    page.assert_selector('li.scheme', count: 0)
    page.should have_content('no matching schemes')
    page.should have_selector('.filter-results-summary h3 span', text: '0') # result count
  end

  it "should show message if no matching schemes" do
    uncheck("recognition-award")
    uncheck("finance")
    uncheck("equity")
    uncheck("loan")
    uncheck("grant")
    select "Exiting", :from => "stage"
    click_on "Refresh results"
    page.assert_selector('li.scheme', count: 0)
    page.should have_content('no matching schemes')
    page.should have_selector('.filter-results-summary h3 span', text: '0') # result count
  end
end
