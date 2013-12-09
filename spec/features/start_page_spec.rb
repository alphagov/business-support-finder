require 'spec_helper'

describe "Start page" do

  specify "Inspecting the start page" do

    visit "/#{APP_SLUG}"

    within '#content' do
      within 'header' do
        page.should have_content("Finance and support for your business")
      end

      within 'article[role=article]' do
        within 'section.intro' do
          page.should have_link("Get started", :href => "/#{APP_SLUG}/search")
        end
      end

      page.should have_selector(".article-container #test-report_a_problem")
    end
    page.should have_selector("#test-related")
  end
end
