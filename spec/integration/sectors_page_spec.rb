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
        page.should have_selector("p.hint", :text => "Your chosen areas will appear here")
        page.should_not have_link("Next step")
      end
    end

    assert_upcoming_questions(
      2 => "What stage is your business at?",
      3 => "How is your business structured?",
      4 => "Where is your business located?"
    )

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
        i_should_see_remove_links_in_order [
          "Education",
          "Hospitality and Catering",
        ]
        i_should_see_selected_sector_links [
          "Education",
          "Hospitality and Catering",
        ]
      end

      within '.business-sector-picked' do
        i_should_see_remove_links_in_order [
          "Education",
          "Hospitality and Catering",
        ]

        page.should have_selector("p.hidden", :text => "Your chosen areas will appear here")
        page.should have_link("Next step", :href => "/#{APP_SLUG}/stage?sectors=education_hospitality-and-catering")
      end
    end
  end

  specify "visiting the page with some sectors pre-selected, and removing a sector" do
    visit "/#{APP_SLUG}/sectors?sectors=health_travel-and-leisure"

    within '.current-question' do
      within '#business-sectors' do
        i_should_see_add_links_in_order [
          "Agriculture",
          "Business and Finance",
          "Construction",
          "Education",
          "Hospitality and Catering",
          "Information, Communication and Media",
          "Manufacturing",
          "Mining",
          "Real Estate",
          "Science and Technology",
          "Service Industries",
          "Transport and Distribution",
          "Utilities",
          "Wholesale and Retail",
        ]
        i_should_see_remove_links_in_order [
          "Health",
          "Travel and Leisure",
        ]
        i_should_see_selected_sector_links [
          "Health",
          "Travel and Leisure",
        ]
      end

      within '.business-sector-picked' do
        i_should_see_remove_links_in_order [
          "Health",
          "Travel and Leisure",
        ]
      end
    end

    click_remove_link('Health')

    i_should_be_on "/#{APP_SLUG}/sectors", :ignore_query => true

    within '.current-question' do
      within '#business-sectors' do
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
          "Utilities",
          "Wholesale and Retail",
        ]
        i_should_see_remove_links_in_order [
          "Travel and Leisure",
        ]
        i_should_see_selected_sector_links [
          "Travel and Leisure",
        ]
      end

      within '.business-sector-picked' do
        i_should_see_remove_links_in_order [
          "Travel and Leisure",
        ]
      end
    end
  end

  specify "adding and removing sectors with js enabled", :js => true do
    visit "/#{APP_SLUG}/sectors"

    dismiss_beta_popup

    within '.current-question' do
      within '.search-picker' do
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

      within '.picked-items' do
        page.should have_selector("p.hint", :text => "Your chosen areas will appear here")
        page.should_not have_link("Next step")
      end
    end

    click_add_link "Service Industries"
    click_add_link "Health"
    click_add_link "Mining"

    within '.current-question' do
      within '.search-picker' do
        i_should_see_add_links_in_order [
          "Agriculture",
          "Business and Finance",
          "Construction",
          "Education",
          "Hospitality and Catering",
          "Information, Communication and Media",
          "Manufacturing",
          "Real Estate",
          "Science and Technology",
          "Transport and Distribution",
          "Travel and Leisure",
          "Utilities",
          "Wholesale and Retail",
        ]
        i_should_see_remove_links_in_order [
          "Health",
          "Mining",
          "Service Industries",
        ]
        i_should_see_selected_sector_links [
          "Health",
          "Mining",
          "Service Industries",
        ]
      end

      within '.picked-items' do
        i_should_see_remove_links_in_order [
          "Health",
          "Mining",
          "Service Industries",
        ]
        page.should have_selector("p.hidden", :text => "Your chosen areas will appear here")
        page.should have_link("Next step")
        page.should have_link("Next step", :href => "/#{APP_SLUG}/stage?sectors=health_mining_service-industries")
      end
    end

    click_remove_link "Mining"
    click_remove_link "Health"
    click_add_link "Mining"


    within '.current-question' do
      within '.search-picker' do
        i_should_see_add_links_in_order [
          "Agriculture",
          "Business and Finance",
          "Construction",
          "Education",
          "Health",
          "Hospitality and Catering",
          "Information, Communication and Media",
          "Manufacturing",
          "Real Estate",
          "Science and Technology",
          "Transport and Distribution",
          "Travel and Leisure",
          "Utilities",
          "Wholesale and Retail",
        ]
        i_should_see_remove_links_in_order [
          "Mining",
          "Service Industries",
        ]
        i_should_see_selected_sector_links [
          "Mining",
          "Service Industries",
        ]
      end

      within '.picked-items' do
        i_should_see_remove_links_in_order [
          "Mining",
          "Service Industries",
        ]
        page.should have_selector("p.hidden", :text => "Your chosen areas will appear here")
        page.should have_link("Next step")
        page.should have_link("Next step", :href => "/#{APP_SLUG}/stage?sectors=mining_service-industries")
      end
    end

    click_on "Next step"

    i_should_be_on "/#{APP_SLUG}/stage?sectors=mining_service-industries"
  end
end
