require 'spec_helper'

describe "Business size page" do

  specify "inspecting the page" do
    visit "/#{APP_SLUG}/size?sectors=health_manufacturing&stage=start-up"

    assert_completed_questions(
      1 => ["What is your activity or business?", ["Health", "Manufacturing"]],
      2 => ["What stage is your business at?", ["Start-up"]]
    )

    assert_current_question(3, "How many employees do you have?")

    within '.current-question' do
      page.should have_select("Select a size", :options => [
        'Select one...',
        'Under 10',
        'Up to 249',
        'Between 250 and 500',
        'Between 501 and 1000',
        'Over 1000'
      ])

      page.should have_button("Next step")
    end

    assert_upcoming_questions(
      4 => "What type of support are you interested in?",
      5 => "Where is your business located?"
    )

    select "Under 10", :from => "Select a size"

    click_on "Next step"

    i_should_be_on "/#{APP_SLUG}/types", :ignore_query => true
  end

  specify "with a size already selected" do
    visit "/#{APP_SLUG}/size?sectors=health_manufacturing&stage=start-up&size=under-10"

    within '.current-question' do
      page.should have_select("Select a size", :options => [
        'Select one...',
        'Under 10',
        'Up to 249',
        'Between 250 and 500',
        'Between 501 and 1000',
        'Over 1000'
      ], :selected => 'Under 10')
    end
  end
end
