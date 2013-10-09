require 'spec_helper'

describe "Types page" do

  specify "inspecting the page" do
    visit "/#{APP_SLUG}/types?sectors=health_manufacturing&stage=start-up&size=under-10"

    assert_completed_questions(
      1 => ["What is your activity or business?", ["Health", "Manufacturing"]],
      2 => ["What stage is your business at?", ["Start-up"]],
      3 => ["How many employees do you have?", ["Under 10"]]
    )

    assert_current_question(4, "What type of support are you interested in?")

    within '.current-question' do
      page.should have_field("Finance (any)", :type => :checkbox)
      page.should have_field("Equity", :type => :checkbox)
      page.should have_field("Grant", :type => :checkbox)
      page.should have_field("Loan (including guarantees)", :type => :checkbox)
      page.should have_field("Expertise and advice", :type => :checkbox)
      page.should have_field("Recognition award", :type => :checkbox)

      page.should have_button("Next step")
    end

    assert_upcoming_questions(
      5 => "Where is your business located?"
    )

    check "Finance (any)"
    check "Loan"

    click_on "Next step"

    i_should_be_on "/#{APP_SLUG}/location", :ignore_query => true
  end

  specify "with types already selected" do
    visit "/#{APP_SLUG}/types?sectors=health_manufacturing&stage=start-up&size=up-to-249&types=loan_expertise-and-advice"

    within '.current-question' do
      page.should have_field("Finance (any)", :type => :checkbox, :checked => false)
      page.should have_field("Equity", :type => :checkbox, :checked => false)
      page.should have_field("Grant", :type => :checkbox, :checked => false)
      page.should have_field("Loan (including guarantees)", :type => :checkbox, :checked => true)
      page.should have_field("Expertise and advice", :type => :checkbox, :checked => true)
      page.should have_field("Recognition award", :type => :checkbox, :checked => false)
    end
  end
end
