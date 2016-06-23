# TaktServerHelper module
#
# Contains several functions used for the messages server
# and updating data on the messages server
#
# @author Christopher Reeves
# @author Craig Reeves

module TaktServerHelper

  # Returns the online service ids from the
  # ids passed in
  def check_online_service_ids(ids)
    result = []
    file = open('data/online_services.json', 'r')
    online_services = JSON.parse(file.gets)

    ids.each do |id|
      if online_services.has_key? id.to_s
        result << id
      end
    end

    result
  end

  # Load current user services and active services
  # This is necessary so that the Takt server is notified
  # on page load of what services are available
  def load_current_user_services
    if logged_in?
      if @current_user.services.count > 0
        @user_services = @current_user.services.sort_by { |s| s.name }
        @active_user_services = @user_services.select {|s| s.is_active && s.is_published }
        @user_service_count = @user_services.count

        # Push info regarding services online to TaktServer
        services_online_info = {event: 'services_online_update', user_id: @current_user.id, services_online: @active_user_services}
        push_to_takt_server services_online_info
      end
    end
  end

  # Push data to messages server
  def push_to_takt_server(data)
    zmq_context = ZMQ::Context.new
    socket = zmq_context.socket(ZMQ::PUSH)
    socket.connect("tcp://localhost:5050")
    socket.send_string(data.to_json)
    socket.close
  end
end