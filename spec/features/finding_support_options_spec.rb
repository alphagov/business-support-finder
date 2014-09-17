require 'spec_helper'

describe "Finding support options" do

  include ImminenceApiHelper

  describe "without javascript" do
    before do
      @regions = [{slug: "london", name: "London", type: "EUR", country_name: "England"},
                  {slug: "south-east", name: "South East", type: "EUR", country_name: "England"},
                  {slug: "england", name: "England", type: "EUR", country_name: "England"},
                  {slug: "scotland", name: "Scotland", type: "EUR", country_name: "Scotland"},
                  {slug: "wales", name: "Wales", type: "EUR", country_name: "Wales"},
                  {slug: "northern-ireland", name: "Northern Ireland", type: "EUR", country_name: "Northern Ireland"}]

      stub_imminence_areas_request(@regions)
    end

    describe "with no facet filtering" do
      before do
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
    end
    describe "with facet filtering" do
      before do
        business_support_api_has_schemes(
          [
            { "title" => "Graduate start-up", "business_support_identifier" => "graduate-start-up",
              "stages" => ["grow-and-sustain"], "business_sizes" => ["up-to-249"], "sectors" => ["education"],
              "support_types" => ["finance", "equity", "grant", "expertise-and-advice"] },
          ],
          {
                "stages" => "grow-and-sustain",
                "business_sizes" => "up-to-249",
                "sectors" => "education",
                "postcode" => "WC2B 6SE",
                "support_types" => "finance,equity,grant,expertise-and-advice",
          }
        )

        visit "/#{APP_SLUG}/search"
      end
      it "should filter results" do
        uncheck("loan")
        uncheck("recognition-award")
        select "10 - 249", :from => "business_sizes"
        select "Education", :from => "sectors"
        select "Grow and sustain", :from => "stages"
        click_on "Refresh results"
        page.assert_selector('li.scheme', count: 1)
        page.should have_content 'Graduate start-up'
        page.should have_selector('.filter-results-summary h3 span', text: '1') # result count
      end

      it "should return no results for incomplete postcodes" do
        fill_in "Business postcode", :with => "WC2B"
        click_on "Refresh results"
        page.assert_selector('li.scheme', count: 0)
      end

      it "should filter results with a valid postcode" do
        fill_in "Business postcode", :with => "WC2B 6SE"
        click_on "Refresh results"
        page.assert_selector('li.scheme', count: 1)
      end
    end
  end

  describe "with javascript enabled" do
    before do
      Capybara.current_driver = Capybara.javascript_driver

      business_support_api_has_schemes([{ 
        "title" => "Graduate start-up", "business_support_identifier" => "graduate-start-up",
        "stages" => ["grow-and-sustain"], "business_sizes" => ["up-to-249"], "sectors" => ["education"],
        "support_types" => ["finance", "equity", "grant", "expertise-and-advice"] }],
        { "postcode" => "WC2B 6SE", "support_types" => "finance,equity,grant,expertise-and-advice" })
      business_support_api_has_schemes([{
        "title" => "Manufacturing Services - Wales", "business_support_identifier" => "manufacturing-services-wales",
        "stages" => ["grow-and-sustain"], "business_sizes" => ["under-10"], "sectors" => ["manufacturing"],
        "support_types" => ["finance", "equity", "grant", "expertise-and-advice"] }],
        { "postcode" => "SA99 1AR", "support_types" => "finance,equity,grant,expertise-and-advice" })

      visit "/#{APP_SLUG}/search"
    end

    it "should filter results in the DOM" do
      page.should have_selector('.filter-results-summary h3 span', text: '2')

      uncheck("loan")
      uncheck("recognition-award")
      select "10 - 249", :from => "business_sizes"
      select "Education", :from => "sectors"
      select "Grow and sustain", :from => "stages"

      page.should have_selector('.filter-results-summary h3 span', text: '1')
      page.find('li.scheme h3').text.should == "Graduate start-up"

      select "1000+", :from => "business_sizes"

      page.should have_selector('.filter-results-summary h3 span', text: '0')

      select "0 - 9", :from => "business_sizes"
      select "Manufacturing", :from => "sectors"

      page.should have_selector('.filter-results-summary h3 span', text: '1')
      page.find('li.scheme h3').text.should == "Manufacturing Services - Wales"

      check "loan"
      check "recognition-award"
      select "Any number of employees", :from => "business_sizes"
      select "All", :from => "sectors"
      select "All", :from => "stages"

      page.should have_selector('.filter-results-summary h3 span', text: '2')
      assert page.find('li.scheme', :text => "Graduate start-up")
      assert page.find('li.scheme', :text => "Manufacturing Services - Wales")
    end

    it "shouldn't filter when the postcode field is changed" do
      page.should have_selector('.filter-results-summary h3 span', text: '2')

      fill_in "Business postcode", :with => "WC2B 6SE"

      page.should have_selector('.filter-results-summary h3 span', text: '2')
    end

    it "should filter by postcode on form submission" do
      fill_in "Business postcode", :with => "WC2B 6SE"

      # The submit button is hidden with js enabled, so mimick the return keypress.
      page.execute_script("$('#document-filter').submit()")

      assert page.find('.filter-results-summary h3 span', text: '1')
      assert page.find('li.scheme', :text => "Graduate start-up")
    end
  end
end
