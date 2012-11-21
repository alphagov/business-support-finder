BusinessSupportFinder::Application.routes.draw do

  get "/#{APP_SLUG}" => "business_support#start", :as => :start
  get "/#{APP_SLUG}/filter-support" => "business_support#filter_submit"
  get "/#{APP_SLUG}/support-options" => "business_support#support_options", :as => :support_options

  root :to => redirect("/#{APP_SLUG}", :status => 302)
end
