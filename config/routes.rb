BusinessSupportFinder::Application.routes.draw do

  with_options :format => false do |routes|
    routes.get "/#{APP_SLUG}" => "business_support#start", :as => :start
    routes.get "/#{APP_SLUG}/sectors" => "business_support#sectors", :as => :sectors
    routes.get "/#{APP_SLUG}/stage" => "business_support#stage", :as => :stage
    routes.post "/#{APP_SLUG}/stage" => "business_support#stage_submit"
    routes.get "/#{APP_SLUG}/size" => "business_support#size", :as => :size
    routes.post "/#{APP_SLUG}/size" => "business_support#size_submit"
    routes.get "/#{APP_SLUG}/types" => "business_support#types", :as => :types
    routes.post "/#{APP_SLUG}/types" => "business_support#types_submit"
    routes.get "/#{APP_SLUG}/location" => "business_support#location", :as => :location
    routes.post "/#{APP_SLUG}/location" => "business_support#location_submit"
    routes.get "/#{APP_SLUG}/support-options" => "business_support#support_options", :as => :support_options
  end

  root :to => redirect("/#{APP_SLUG}", :status => 302)
end
