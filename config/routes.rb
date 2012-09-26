BusinessSupportFinder::Application.routes.draw do

  get "/#{APP_SLUG}" => "business_support#start", :as => :start
  get "/#{APP_SLUG}/sectors" => "business_support#sectors", :as => :sectors
  get "/#{APP_SLUG}/stage" => "business_support#stage", :as => :stage
  post "/#{APP_SLUG}/stage" => "business_support#stage_submit"
  get "/#{APP_SLUG}/structure" => "business_support#structure", :as => :structure

  root :to => redirect("/#{APP_SLUG}", :status => 302)
end
