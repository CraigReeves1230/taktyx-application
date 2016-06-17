# ServicesController
#
# @author Christopher Reeves
# @author Craig Reeves
# @copyright (c) 2016 by Taktyx

#
# This controller governs all actions regarding services
#
class ServicesController < ApplicationController

  # Main page where users would create and view services
  def create_edit

    # User must be logged in or authorized to view this page
    unless logged_in?
      redirect_to login_path
    end

    # GON is a GEM that lets us
    # Pass variables to Javascript
    # Load categories to populate view
    gon.categories = Category.all.order :name
  end

  # Validates and persists service
  def do_create

    # User must be logged in or authorized to view this page
    if logged_in?
      render json: Service.save_new(params[:service], auth_user)
    else
      # User must be logged in to create services
      render json: {:has_error => true, :data => {unauth: true}}
    end
  end
end
