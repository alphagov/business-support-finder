require 'spec_helper'

describe "Redirecting the root URL" do
  it "should redirect to the start page" do
    get "/"

    response.should redirect_to("/business-finance-support-finder")
  end
end
