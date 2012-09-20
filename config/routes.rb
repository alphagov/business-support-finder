BusinessSupportFinder::Application.routes.draw do

  root :to => redirect("/#{APP_SLUG}", :status => 302)
end
