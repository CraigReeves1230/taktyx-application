class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :check_for_current_user
  before_action :load_current_user_services

  include Authentication
  include TaktServerHelper

end
