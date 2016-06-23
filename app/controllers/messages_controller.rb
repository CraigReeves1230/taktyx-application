# MessagesController
#
# @author Christopher Reeves
# @copyright (c) 2016 by Taktyx

#
# Actions in this controller pertain to message creation, updating, deleting
# and sending
#
class MessagesController < ApplicationController

  before_action :verify_activation

  # Save message to service
  def do_create
    message = Message.new({})
    message.sender_id = 6
    message.recipient_id = 63
    message.content = "Do ya'll do brake shoes?"
    message.save

    push_to_takt_server({event: 'update_takts_signal', recipient_id: message.recipient_id})
  end

  # Fetches takts for service
  def fetch

    service_id = params['service']
    service = Service.find_by_id service_id
    if service.nil?
      return_val = {:has_errors => true, :data => 'Service cannot be located.'}
    else
      messages = service.messages.order(created_at: :desc)
      return_val = {:has_errors => false, :takts => messages}
    end

    render json: return_val
  end

  # Deletes takt from server
  def do_delete
    message_id = params['id']
    message = Message.find_by_id message_id
    if message.nil?
      return_val = {:has_errors => true, :data => 'The Takt cannot be located or has already been deleted.'}
    else
      message.delete
      return_val = {:has_errors => false}
    end

    render json: return_val
  end
end
