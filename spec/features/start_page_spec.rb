require 'rails_helper'

RSpec.describe "Start page" do

  specify "Inspecting the start page" do

    visit "/#{APP_SLUG}"

    within 'head', visible: :all do
      expect(page).to have_selector("meta[@name='description']", visible: false)
    end

    within '#content' do
      within 'header' do
        expect(page).to have_content("Finance and support for your business")
      end

      within 'article[role=article]' do
        within 'section.intro' do
          expect(page).to have_link("Get started", :href => "/#{APP_SLUG}/search")
        end
      end
    end
    expect(page).to have_selector("#test-related")
  end
end
