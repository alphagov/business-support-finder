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
end
