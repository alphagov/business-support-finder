require 'spec_helper'

describe "Start page" do

  specify "Inspecting the start page" do

    visit "/#{APP_SLUG}"

    within 'section#content' do
      within 'header' do
        page.should have_content("Business finance and support finder")
        page.should have_content("Quick answer")
      end

      within 'article[role=article]' do
        within 'section.intro' do
          page.should have_link("Get started", :href => '#')
        end
      end

      page.should have_selector(".article-container #test-report_a_problem")
    end
  end
end
