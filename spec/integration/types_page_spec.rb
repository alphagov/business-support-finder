require 'spec_helper'

describe "Types page" do

  specify "inspecting the page" do
    visit "/#{APP_SLUG}/types?sectors=health_manufacturing&stage=start-up&structure=partnership"

    assert_completed_questions(
      1 => ["What is your activity or business?", ["Health", "Manufacturing"]],
      2 => ["What stage is your business at?", ["Start-up"]],
      3 => ["How is your business structured?", ["Partnership"]]
    )

    assert_current_question(4, "What type of support are you interested in?")

    within '.current-question' do
      page.should have_select("Select a type of business support", :options => [
        'Select one...',
        'Finance, grants and loans',
        'Expertise, advice and finance'
      ])

      page.should have_button("Next step")
    end

    assert_upcoming_questions(
      5 => "Where is your business located?"
    )

    select "Finance", :from => "Select a type of business support"

    click_on "Next step"

    i_should_be_on "/#{APP_SLUG}/location", :ignore_query => true
  end

  specify "with a type already selected" do
    visit "/#{APP_SLUG}/types?sectors=health_manufacturing&stage=start-up&structure=sole-trader&types=finance"

    within '.current-question' do
      page.should have_select("Select a type of business support", :options => [
        'Select one...',
        'Finance, grants and loans',
        'Expertise, advice and finance',
      ], :selected => 'Finance, grants and loans')
    end
  end
end
