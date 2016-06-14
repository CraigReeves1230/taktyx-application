class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action 'bootstrap'

  # Initialize variables for all controllers
  def bootstrap

    # Get the currently logged in user
    if session.has_key? :user_id
      @auth_user ||= User.find(session[:user_id])
    end

  end
end
