require 'spec_helper'

describe "Support options page" do

  specify "inspecting the support options page" do
    visit "/#{APP_SLUG}/support-options?sectors=health_manufacturing&stage=start-up&structure=partnership&location=england"

    assert_completed_questions(
      1 => ["What is your activity or business?", ["Health", "Manufacturing"]],
      2 => ["What stage is your business at?", ["Start-up"]],
      3 => ["How is your business structured?", ["Partnership"]],
      4 => ["Where is your business located?", ["England"]]
    )

    page.should_not have_selector('.completed-questions')

    page.should have_content("Available support")
  end

  specify "inspecting the 'change this answer' links" do
    visit "/#{APP_SLUG}/support-options?sectors=health_manufacturing&stage=start-up&structure=partnership&location=england"

    within_section "completed question 1" do
      page.should have_link("Change this answer", :href => "/#{APP_SLUG}/sectors?location=england&sectors=health_manufacturing&stage=start-up&structure=partnership")
    end
    within_section "completed question 2" do
      page.should have_link("Change this answer", :href => "/#{APP_SLUG}/stage?location=england&sectors=health_manufacturing&stage=start-up&structure=partnership")
    end
    within_section "completed question 3" do
      page.should have_link("Change this answer", :href => "/#{APP_SLUG}/structure?location=england&sectors=health_manufacturing&stage=start-up&structure=partnership")
    end
    within_section "completed question 4" do
      page.should have_link("Change this answer", :href => "/#{APP_SLUG}/location?location=england&sectors=health_manufacturing&stage=start-up&structure=partnership")
    end
  end
end
