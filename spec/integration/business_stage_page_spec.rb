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
        'Pre-start',
        'Start-up',
        'Grow and sustain',
        'Exiting a business'
      ])

      page.should have_button("Next step")
    end

    assert_upcoming_questions(
      3 => "How is your business structured?",
      4 => "What type of support are you interested in?",
      5 => "Where is your business located?"
    )

    select "Grow and sustain", :from => "Select a stage"

    click_on "Next step"

    i_should_be_on "/#{APP_SLUG}/structure", :ignore_query => true
  end

  specify "with a stage already selected" do
    visit "/#{APP_SLUG}/stage?sectors=health_manufacturing&stage=grow-and-sustain"

    within '.current-question' do
      page.should have_select("Select a stage", :options => [
        'Select one...',
        'Pre-start',
        'Start-up',
        'Grow and sustain',
        'Exiting a business'
      ], :selected => 'Grow and sustain')
    end
  end
end
