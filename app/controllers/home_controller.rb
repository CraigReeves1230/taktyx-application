# HomeController
#
# @author Christopher Reeves
# @copyright (c) 2016 by Taktyx

#
# The main entry point of the application
#
class HomeController < ApplicationController

  # The main page of the site
  def index

    # If the user logged in has services, push that to javascript datalayer for Takt Server access
    if logged_in?
      if @current_user.services.select {|s| s.is_active }.count > 0
        gon.user_active_services = @current_user.services.select {|s| s.is_active }
      end
    end
  end
end
