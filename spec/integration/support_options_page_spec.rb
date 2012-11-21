require 'spec_helper'

describe "Support options page" do

  specify "inspecting the support options page" do
    imminence_has_business_support_schemes(
      {
        "sectors" => "health,manufacturing",
        "stages" => "start-up",
        "business_types" => "partnership",
        "locations" => "england",
        "types" => "finance,grant,loan"
      },
      [
        {"title" => "Graduate start-up", "business_support_identifier" => "graduate-start-up"},
        {"title" => "High Potential Starts", "business_support_identifier" => "high-potential-starts"},
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

    visit "/#{APP_SLUG}/support-options?sectors=health_manufacturing&stages=start-up&structures=partnership&locations=england&types=finance_grant_loan"

    within '.results' do
      page.should have_content("Available support")

      page.all("li a").map(&:text).should == ["Graduate start-up scheme", "Manufacturing Services scheme - Wales"]
      within_section "list item containing Graduate start-up scheme" do
        page.should have_link("Graduate start-up scheme", :href => "https://www.gov.uk/graduate-start-up")
        page.should have_content("Some blurb abour the Graduate start-up scheme")
      end
      within_section "list item containing Manufacturing Services scheme - Wales" do
        page.should have_link("Manufacturing Services scheme - Wales", :href => "https://www.gov.uk/wales/manufacturing-services-scheme")
        page.should have_content("Some blurb abour the welsh Manufacturing services scheme")
      end
      # Doesn't have the item that's in imminence, but not in content_api
    end
  end

  specify "inspecting the support options page with no results" do
    imminence_has_business_support_schemes(
      {
        "sectors" => "health,manufacturing",
        "stages" => "start-up",
        "business_types" => "partnership",
        "locations" => "england",
        "types" => "finance"
      },
      [
        {"title" => "Graduate start-up", "business_support_identifier" => "graduate-start-up"},
      ]
    )

    visit "/#{APP_SLUG}/support-options?sectors=health_manufacturing&stages=start-up&structures=partnership&locations=england&types=finance"

    within '.results' do
      page.should have_content("No business support schemes were found that match your search.")

      page.should have_link("Start again", :href => "/#{APP_SLUG}/support-options")

      page.should_not have_content("Available support")
    end
  end

end
