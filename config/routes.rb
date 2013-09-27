BusinessSupportFinder::Application.routes.draw do

  with_options :format => false do |routes|
    routes.get "/#{APP_SLUG}" => "business_support#start", :as => :start
    routes.get "/#{APP_SLUG}/search" => "business_support#search", :as => :search
  end

  root :to => redirect("/#{APP_SLUG}", :status => 302)
end
