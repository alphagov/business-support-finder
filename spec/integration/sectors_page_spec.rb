require 'spec_helper'

describe "selecting business sectors" do

  specify "inspecting the page, and adding some sectors" do
    visit "/#{APP_SLUG}/sectors"

    page.should_not have_selector('.done-questions')

    assert_current_question(1, "What is your activity or business?")

    within '.current-question' do
      within '#business-sectors' do
        page.should have_content("Choose your area of business")

        i_should_see_add_links_in_order [
          "Agriculture",
          "Business and Finance",
          "Construction",
          "Education",
          "Health",
          "Hospitality and Catering",
          "Information, Communication and Media",
          "Manufacturing",
          "Mining",
          "Real Estate",
          "Science and Technology",
          "Service Industries",
          "Transport and Distribution",
          "Travel and Leisure",
          "Utilities",
          "Wholesale and Retail",
        ]
      end

      within '.business-sector-picked' do
        page.should have_content("Your chosen areas will appear here")
      end
    end

    assert_upcoming_questions(
      2 => "What stage is your business at?",
      3 => "How is your business structured?",
      4 => "Where will you be located?"
    )

    pending "Hooking up Add links"

    click_add_link "Education"
    click_add_link "Hospitality and Catering"

    i_should_be_on "/#{APP_SLUG}/sectors", :ignore_query => true

    within '.current-question' do
      within '#business-sectors' do
        i_should_see_add_links_in_order [
          "Agriculture",
          "Business and Finance",
          "Construction",
          "Health",
          "Information, Communication and Media",
          "Manufacturing",
          "Mining",
          "Real Estate",
          "Science and Technology",
          "Service Industries",
          "Transport and Distribution",
          "Travel and Leisure",
          "Utilities",
          "Wholesale and Retail",
        ]
      end

      within '.business-sector-picked' do
        i_should_see_remove_links [
          "Education",
          "Hospitality and Catering",
        ]

        page.should have_link("Next step", :href => "/#{APP_SLUG}/stage")
      end
    end
  end

end
