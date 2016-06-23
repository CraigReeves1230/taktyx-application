# ServicesController
#
# @author Christopher Reeves
# @copyright (c) 2016 by Taktyx

#
# This controller governs all actions regarding services
#
class ServicesController < ApplicationController

  # Before filter
  before_action :verify_activation
  before_action :require_logged_in, only: [:create_edit]

  include TaktServerHelper

  # Main page where users would create and view services
  def create_edit

    # GON is a GEM that lets us
    # Pass variables to Javascript
    # Load categories to populate view
    gon.categories = Category.all.order :name

    # Pass data on services to view
    gon.user_services = @user_services
    gon.user_service_count = @user_service_count
    gon.active_user_services = @active_user_services
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

  # Update online status of a service
  def do_update_status

    service_id = params['id']

    service = Service.find_by_id(service_id)
    if service.nil?
      return_val = {:has_errors => true, :data => 'Service with id ' << service_id << ' cannot be found.'}
    else
      service.is_active = !service.is_active
      service.save

      # Update push server
      push_to_takt_server({event: 'update_service_status', service: service})

      return_val = {:has_errors => false}
    end

    render json: return_val
  end
end
