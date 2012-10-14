require 'spec_helper'

describe "Support options page" do

  specify "inspecting the support options page" do
    imminence_has_business_support_schemes(
      {
        "sectors" => "health,manufacturing",
        "stages" => "start-up",
        "business_types" => "partnership",
        "locations" => "england",
        "types" => "finance,grant,loan,equity"
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

    visit "/#{APP_SLUG}/support-options?sectors=health_manufacturing&stage=start-up&structure=partnership&location=england&types=finance"

    assert_completed_questions(
      1 => ["What is your activity or business?", ["Health", "Manufacturing"]],
      2 => ["What stage is your business at?", ["Start-up"]],
      3 => ["How is your business structured?", ["Partnership"]],
      4 => ["What type of support are you interested in?", ["Finance, grants and loans"]],
      5 => ["Where is your business located?", ["England"]]
    )

    page.should_not have_selector('.completed-questions')

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

  specify "inspecting the 'change this answer' links" do
    visit "/#{APP_SLUG}/support-options?sectors=health_manufacturing&stage=start-up&structure=partnership&location=england&types=finance"

    within_section "completed question 1" do
      page.should have_link("Change this answer", :href => "/#{APP_SLUG}/sectors?location=england&sectors=health_manufacturing&stage=start-up&structure=partnership&types=finance")
    end
    within_section "completed question 2" do
      page.should have_link("Change this answer", :href => "/#{APP_SLUG}/stage?location=england&sectors=health_manufacturing&stage=start-up&structure=partnership&types=finance")
    end
    within_section "completed question 3" do
      page.should have_link("Change this answer", :href => "/#{APP_SLUG}/structure?location=england&sectors=health_manufacturing&stage=start-up&structure=partnership&types=finance")
    end
    within_section "completed question 4" do
      page.should have_link("Change this answer", :href => "/#{APP_SLUG}/types?location=england&sectors=health_manufacturing&stage=start-up&structure=partnership&types=finance")
    end
    within_section "completed question 5" do
      page.should have_link("Change this answer", :href => "/#{APP_SLUG}/location?location=england&sectors=health_manufacturing&stage=start-up&structure=partnership&types=finance")
    end
  end
end
