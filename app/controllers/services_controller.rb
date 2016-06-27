# ServicesController
#
# @author Christopher Reeves
# @copyright (c) 2016 by Taktyx

#
# This controller governs all actions regarding services
#
class ServicesController < ApplicationController

  # Before filter
  before_action :verify_activation, only: [:create_edit]
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
      render json: service.create_or_save(params[:service], @current_user)
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

  # Do service update
  def do_update

    # User must be logged in
    if !@current_user.nil?
      service_id = params['id']
      service = Service.find_by_id service_id
      if !service.nil?

        return_val = service.create_or_save(params['service'], @current_user)
      else
        return_val = {:has_errors => true, :data => 'Service cannot be found or has been deleted.'}
      end
    else
      return_val = {:has_errors => true, :data => 'You must be logged in to update services.'}
    end

    render json: return_val
  end

  # Delete a service
  def do_delete
    service = Service.find_by_id params['id']

    # TODO: Associations with address need to be fixed

    {:has_errors => false}
  end

  # Fetch data about service and returns JSON data
  def get_data
    service_id = params['id']
    if service_id != 'all'
      service = Service.find_by_id service_id
      if !service.nil?
        service_address = service.address
        return_val = {:has_errors => false, :service => service, :address => service_address}
      else
        return_val = {:has_errors => true, :data => 'Service cannot be found or has been deleted.'}
      end
    else
      # Get all services
      return_val = {:has_errors => false, :services => Service.select {|s| s.user_id == @current_user.id}.sort_by { |s| s.name }}
    end

    render json: return_val
  end
end
