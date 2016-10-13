require 'rails_helper'

RSpec.describe "Start page" do
  before do
    stub_request(:get, %r{#{Plek.new.find("static")}/templates/locales})
      .to_return(body: {}.to_json)
  end

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
    expect(page).to have_css(shared_component_selector('breadcrumbs'))
    expect(page).to have_css(shared_component_selector('related_items'))
  end
end
