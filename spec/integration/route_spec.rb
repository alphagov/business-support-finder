require "spec_helper"

describe "Redirecting the root URL" do
  it "should redirect to the start page" do
    get "/"
    response.should redirect_to("/#{APP_SLUG}")
  end

  it "should redirect /sectors to start page" do
    get "/#{APP_SLUG}/sectors"
    response.should redirect_to("/#{APP_SLUG}")
  end

  it "should redirect /stage to start page" do
    get "/#{APP_SLUG}/stage"
    response.should redirect_to("/#{APP_SLUG}")
  end

  it "should forbid posts /stage" do
    post "/#{APP_SLUG}/stage"
    response.status.should == 403
  end

  it "should redirect /size to start page" do
    get "/#{APP_SLUG}/size"
    response.should redirect_to("/#{APP_SLUG}")
  end

  it "should forbid posts /size" do
    post "/#{APP_SLUG}/size"
    response.status.should == 403
  end

  it "should redirect /types to start page" do
    get "/#{APP_SLUG}/types"
    response.should redirect_to("/#{APP_SLUG}")
  end

  it "should forbid posts /types" do
    post "/#{APP_SLUG}/types"
    response.status.should == 403
  end

  it "should redirect /location to start page" do
    get "/#{APP_SLUG}/location"
    response.should redirect_to("/#{APP_SLUG}")
  end

  it "should forbid posts /location" do
    post "/#{APP_SLUG}/location"
    response.status.should == 403
  end

  it "should redirect /support-options to start page" do
    get "/#{APP_SLUG}/support-options"
    response.should redirect_to("/#{APP_SLUG}")
  end
end
