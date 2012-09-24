require 'spec_helper'

describe "Finding support options" do

  specify "Happy path through the app" do
    visit "/#{APP_SLUG}"

    page.should have_link("Get started")

    click_on "Get started"

    i_should_be_on "/#{APP_SLUG}/sectors"

    within '.current-question' do
      page.should have_content("What is your activity or business?")
    end

    click_add_link "Education"
    click_add_link "Hospitality and Catering"

    click_on "Next step"

    pending "completion of stage page"

    i_should_be_on "/#{APP_SLUG}/stage", :ignore_query => true

    within_section 'completed question 1' do
      page.should have_content("Education")
      page.should have_content("Hospitality and Catering")
    end

    within '.current-question' do
      page.should have_content("What stage is your business at?")

      select 'Start-up', :from => 'Choose a stage'
      click_on 'Next stage'
    end

    i_should_be_on "/#{APP_SLUG}/structure", :ignore_query => true

    within_section 'completed question 1' do
      page.should have_content("Education")
      page.should have_content("Hospitality and Catering")
    end
    within_section 'completed question 2' do
      page.should have_content("Start-up")
    end

    within '.current-question' do
      page.should have_content("How is your business structured?")

      select 'Public limited company', :from => "Choose a structure"
      click_on 'Next stage'
    end

    i_should_be_on "/#{APP_SLUG}/location", :ignore_query => true

    within_section 'completed question 1' do
      page.should have_content("Education")
      page.should have_content("Hospitality and Catering")
    end
    within_section 'completed question 2' do
      page.should have_content("Start-up")
    end
    within_section 'completed question 3' do
      page.should have_content("Public limited company")
    end

    within '.current-question' do
      page.should have_content("Where is your business located?")

      select 'Wales', :from => "Select a location"
      click_on 'Find support'
    end

    i_should_be_on "/#{APP_SLUG}/support-options", :ignore_query => true

    page.should have_content("Available support")
  end
end
