# ServicesController
#
# @author Christopher Reeves
# @author Craig Reeves
# @copyright (c) 2016 by Taktyx

#
# This controller governs all actions regarding services
#
class ServicesController < ApplicationController

  # Before filter
  before_action :verify_activation
  before_action :require_logged_in, only: [:create_edit]

  include ServiceServer

  # Main page where users would create and view services
  def create_edit

    # TODO: Move this to a before action
    if logged_in?
      if @current_user.services.select {|s| s.is_active }.count > 0
        gon.user_active_services = @current_user.services.select {|s| s.is_active }
      end
    end

    # GON is a GEM that lets us
    # Pass variables to Javascript
    # Load categories to populate view
    gon.categories = Category.all.order :name

    # Find services for user
    gon.services = @current_user.services.sort_by { |s| s.name }
    @service_count = @current_user.services.count
  end

  # Validates and persists service
  def do_create

    # User must be logged in or authorized to view this page
    if logged_in?
      service = Service.new({})
      render json: service.save_new(params[:service], @current_user)
    else
      # User must be logged in to create services
      render json: {:has_error => true, :data => {unauth: true}}
    end
  end
end
