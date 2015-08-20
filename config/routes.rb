Rails.application.routes.draw do

  with_options :format => false do |routes|
    routes.get "/#{APP_SLUG}" => "business_support#start", :as => :start
    routes.get "/#{APP_SLUG}/search" => "business_support#search", :as => :search

    # Routes from old application
    routes.get "/#{APP_SLUG}/sectors", :to => redirect("/#{APP_SLUG}")
    routes.get "/#{APP_SLUG}/stage", :to => redirect("/#{APP_SLUG}")
    routes.post "/#{APP_SLUG}/stage" => "application#error_403"
    routes.get "/#{APP_SLUG}/size", :to => redirect("/#{APP_SLUG}")
    routes.post "/#{APP_SLUG}/size" => "application#error_403"
    routes.get "/#{APP_SLUG}/types", :to => redirect("/#{APP_SLUG}")
    routes.post "/#{APP_SLUG}/types" => "application#error_403"
    routes.get "/#{APP_SLUG}/location", :to => redirect("/#{APP_SLUG}")
    routes.post "/#{APP_SLUG}/location" => "application#error_403"
    routes.get "/#{APP_SLUG}/support-options", :to => redirect("/#{APP_SLUG}")
  end

  root :to => redirect("/#{APP_SLUG}", :status => 302)
end
