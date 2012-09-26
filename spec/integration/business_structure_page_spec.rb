require 'spec_helper'

describe "Business structure page" do

  specify "inspecting the page" do
    visit "/#{APP_SLUG}/structure?sectors=health_manufacturing&stage=start-up"

    assert_completed_questions(
      1 => ["What is your activity or business?", ["Health", "Manufacturing"]],
      2 => ["What stage is your business at?", ["Start-up"]]
    )

    assert_current_question(3, "How is your business structured?")

    within '.current-question' do
      page.should have_select("Select a structure", :options => [
        'Select one...',
        'Private company',
        'Partnership',
        'Public limited company',
        'Sole trader',
        'Social enterprise',
        'Charity',
      ], :selected => nil)

      page.should have_button("Next step")
    end

    assert_upcoming_questions(
      4 => "Where will you be located?"
    )

    select "Sole trader", :from => "Select a structure"

    click_on "Next step"

    i_should_be_on "/#{APP_SLUG}/location", :ignore_query => true
  end
end
