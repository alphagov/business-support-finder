BusinessSupportFinder::Application.routes.draw do

  get "/#{APP_SLUG}" => "business_support#start"
  get "/#{APP_SLUG}/sectors" => "business_support#sectors", :as => :sectors

  root :to => redirect("/#{APP_SLUG}", :status => 302)
end
