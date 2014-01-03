require 'spec_helper'

describe "Finding support options" do

  describe "without javascript" do
    before do
      business_support_api_has_schemes(
        [
          {"title" => "Graduate start-up", "business_support_identifier" => "graduate-start-up"},
          {"title" => "Manufacturing Services - Wales", "business_support_identifier" => "manufacturing-services-wales"},
        ]
      )
      business_support_api_has_schemes(
        [
          { "title" => "Graduate start-up", "business_support_identifier" => "graduate-start-up",
            "support_types" => ["finance", "equity", "grant", "loan", "expertise-and-advice", "recognition-award"] },
          { "title" => "Manufacturing Services - Wales", "business_support_identifier" => "manufacturing-services-wales",
            "support_types" => ["finance", "equity", "grant", "loan", "expertise-and-advice", "recognition-award"] },
        ],
        {
          "support_types" => "finance,equity,grant,loan,expertise-and-advice,recognition-award",
        }
      )
      business_support_api_has_schemes(
        [
          { "title" => "Graduate start-up", "business_support_identifier" => "graduate-start-up",
            "stages" => ["grow-and-sustain"], "business_sizes" => ["up-to-249"], "sectors" => ["education"],
            "locations" => ["london"], "support_types" => ["finance", "equity", "grant", "expertise-and-advice"] },
        ],
        {
              "stages" => "grow-and-sustain",
              "business_sizes" => "up-to-249",
              "sectors" => "education",
              "locations" => "london",
              "support_types" => "finance,equity,grant,expertise-and-advice",
        }
      )

      visit "/#{APP_SLUG}/search"
    end

    it "should show all available schemes by default" do
      page.should have_content 'Graduate start-up'
      page.should have_content 'Manufacturing Services - Wales'
      page.assert_selector('li.scheme', count: 2)
      page.should have_selector('.filter-results-summary h3 span', text: '2') # result count
    end

    it "should show all available schemes if unchanged form submitted" do
      click_on "Refresh results"
      page.should have_content 'Graduate start-up'
      page.should have_content 'Manufacturing Services - Wales'
      page.assert_selector('li.scheme', count: 2)
      page.should have_selector('.filter-results-summary h3 span', text: '2') # result count
    end

    it "should show 'no matching' if all checkboxes unchecked" do
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

    it "should allow filtering" do
      uncheck("loan")
      uncheck("recognition-award")
      select "London", :from => "location"
      select "10 - 249", :from => "size"
      select "Education", :from => "sector"
      select "Grow and sustain", :from => "stage"
      click_on "Refresh results"
      page.assert_selector('li.scheme', count: 1)
      page.should have_content 'Graduate start-up'
      page.should have_selector('.filter-results-summary h3 span', text: '1') # result count
    end
  end

  describe "with javascript enabled" do
    before do
      Capybara.current_driver = Capybara.javascript_driver

      business_support_api_has_schemes(
        [
          { "title" => "Graduate start-up", "business_support_identifier" => "graduate-start-up",
            "stages" => ["grow-and-sustain"], "business_sizes" => ["up-to-249"], "sectors" => ["education"],
            "locations" => ["london"], "support_types" => ["finance", "equity", "grant", "expertise-and-advice"] },
          { "title" => "Manufacturing Services - Wales", "business_support_identifier" => "manufacturing-services-wales",
            "stages" => ["grow-and-sustain"], "business_sizes" => ["under-10"], "sectors" => ["manufacturing"],
            "locations" => ["wales"], "support_types" => ["finance", "equity", "grant", "expertise-and-advice"] } 
        ]
      )

      visit "/#{APP_SLUG}/search"

      BusinessSupportController.any_instance.should_not_receive(:search)
    end

    it "should filter results in the DOM" do
      page.should have_selector('.filter-results-summary h3 span', text: '2')

      uncheck("loan")
      uncheck("recognition-award")
      select "London", :from => "location"
      select "10 - 249", :from => "size"
      select "Education", :from => "sector"
      select "Grow and sustain", :from => "stage"

      page.should have_selector('.filter-results-summary h3 span', text: '1')
      page.find('li.scheme h3').text.should == "Graduate start-up"

      select "Scotland", :from => "location"
      select "1000+", :from => "size"

      page.should have_selector('.filter-results-summary h3 span', text: '0')

      select "Wales", :from => "location"
      select "0 - 9", :from => "size"
      select "Manufacturing", :from => "sector"

      page.should have_selector('.filter-results-summary h3 span', text: '1')
      page.find('li.scheme h3').text.should == "Manufacturing Services - Wales"

      check "loan"
      check "recognition-award"
      select "Any location", :from => "location"
      select "Any number of employees", :from => "size"
      select "All", :from => "sector"
      select "All", :from => "stage"

      page.should have_selector('.filter-results-summary h3 span', text: '2')
      assert page.find('li.scheme', :text => "Graduate start-up")
      assert page.find('li.scheme', :text => "Manufacturing Services - Wales")
    end
  end
end
