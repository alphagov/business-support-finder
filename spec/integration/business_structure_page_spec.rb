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
      ])

      page.should have_button("Next step")
    end

    assert_upcoming_questions(
      4 => "What type of support are you interested in?",
      5 => "Where is your business located?"
    )

    select "Sole trader", :from => "Select a structure"

    click_on "Next step"

    i_should_be_on "/#{APP_SLUG}/types", :ignore_query => true
  end

  specify "with a structure already selected" do
    visit "/#{APP_SLUG}/structure?sectors=health_manufacturing&stage=start-up&structure=sole-trader"

    within '.current-question' do
      page.should have_select("Select a structure", :options => [
        'Select one...',
        'Private company',
        'Partnership',
        'Public limited company',
        'Sole trader',
        'Social enterprise',
        'Charity',
      ], :selected => 'Sole trader')
    end
  end
end
