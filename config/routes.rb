BusinessSupportFinder::Application.routes.draw do

  get "/#{APP_SLUG}" => "business_support#start"

  root :to => redirect("/#{APP_SLUG}", :status => 302)
end
