require 'rails_helper'

RSpec.describe "Redirecting the root URL" do
  it "should redirect to the start page" do
    get "/"
    expect(response).to redirect_to("/#{APP_SLUG}")
  end

  it "should redirect /sectors to start page" do
    get "/#{APP_SLUG}/sectors"
    expect(response).to redirect_to("/#{APP_SLUG}")
  end

  it "should redirect /stage to start page" do
    get "/#{APP_SLUG}/stage"
    expect(response).to redirect_to("/#{APP_SLUG}")
  end

  it "should forbid posts /stage" do
    post "/#{APP_SLUG}/stage"
    expect(response.status).to eq(403)
  end

  it "should redirect /size to start page" do
    get "/#{APP_SLUG}/size"
    expect(response).to redirect_to("/#{APP_SLUG}")
  end

  it "should forbid posts /size" do
    post "/#{APP_SLUG}/size"
    expect(response.status).to eq(403)
  end

  it "should redirect /types to start page" do
    get "/#{APP_SLUG}/types"
    expect(response).to redirect_to("/#{APP_SLUG}")
  end

  it "should forbid posts /types" do
    post "/#{APP_SLUG}/types"
    expect(response.status).to eq(403)
  end

  it "should redirect /location to start page" do
    get "/#{APP_SLUG}/location"
    expect(response).to redirect_to("/#{APP_SLUG}")
  end

  it "should forbid posts /location" do
    post "/#{APP_SLUG}/location"
    expect(response.status).to eq(403)
  end

  it "should redirect /support-options to start page" do
    get "/#{APP_SLUG}/support-options"
    expect(response).to redirect_to("/#{APP_SLUG}")
  end
end
