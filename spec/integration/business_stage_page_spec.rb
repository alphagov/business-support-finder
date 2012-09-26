require 'spec_helper'

describe "Business stage page" do

  specify "inspecting the page" do
    visit "/#{APP_SLUG}/stage?sectors=health_manufacturing"

    assert_completed_questions(
      1 => ["What is your activity or business?", ["Health", "Manufacturing"]]
    )

    assert_current_question(2, "What stage is your business at?")

    within '.current-question' do
      page.should have_select("Select a stage", :options => [
        'Select one...',
        'Pre-startup',
        'Start-up',
        'Grow and sustain',
        'Exiting a business',
      ], :selected => nil)

      page.should have_button("Next step")
    end

    assert_upcoming_questions(
      3 => "How is your business structured?",
      4 => "Where will you be located?"
    )

    select "Grow and sustain", :from => "Select a stage"

    click_on "Next step"

    i_should_be_on "/#{APP_SLUG}/structure", :ignore_query => true
  end
end
