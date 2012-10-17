class ApplicationController < ActionController::Base
  protect_from_forgery

  def set_expiry(duration = 30.minutes)
    unless Rails.env.development?
      expires_in(duration, :public => true)
    end
  end
end
