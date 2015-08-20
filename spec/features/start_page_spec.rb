require 'rails_helper'

describe "Start page" do

  specify "Inspecting the start page" do

    visit "/#{APP_SLUG}"

    within 'head', visible: :all do
      page.should have_selector("meta[@name='description']", visible: false)
    end

    within '#content' do
      within 'header' do
        page.should have_content("Finance and support for your business")
      end

      within 'article[role=article]' do
        within 'section.intro' do
          page.should have_link("Get started", :href => "/#{APP_SLUG}/search")
        end
      end
    end
    page.should have_selector("#test-related")
  end
end
