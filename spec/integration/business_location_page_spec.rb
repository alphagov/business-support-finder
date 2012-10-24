require 'spec_helper'

describe "Business location page" do

  specify "inspecting the page" do
    visit "/#{APP_SLUG}/location?sectors=health_manufacturing&stage=start-up&structure=partnership&types=finance"

    assert_completed_questions(
      1 => ["What is your activity or business?", ["Health", "Manufacturing"]],
      2 => ["What stage is your business at?", ["Start-up"]],
      3 => ["How is your business structured?", ["Partnership"]],
      4 => ["What type of support are you interested in?", ["Finance, grants and loans"]]
    )

    assert_current_question(5, "Where is your business located?")

    within '.current-question' do
      page.should have_select("Select a location", :options => [
        'Select one...',
        'England',
        'Scotland',
        'Wales',
        'Northern Ireland',
      ])

      page.should have_button("Find support")
    end

    page.should_not have_selector('.upcoming-questions')

    select "England", :from => "Select a location"

    click_on "Find support"

    i_should_be_on "/#{APP_SLUG}/support-options", :ignore_query => true
  end

  specify "with a location already selected" do
    visit "/#{APP_SLUG}/location?sectors=health_manufacturing&stage=start-up&structure=partnership&types=finance&location=wales"

    within '.current-question' do
      page.should have_select("Select a location", :options => [
        'Select one...',
        'England',
        'Scotland',
        'Wales',
        'Northern Ireland',
      ], :selected => 'Wales')
    end
  end
end
