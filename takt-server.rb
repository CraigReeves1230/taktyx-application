require 'eventmachine'
require 'em-websocket'
require 'json'
require 'byebug'
require 'ffi-rzmq'
require 'to_boolean'

zmq_context = ZMQ::Context.new
puller = zmq_context.socket(ZMQ::PULL)
puller.bind("tcp://*:5050")

# TODO: Create a class that represents a client
clients = {}
services_online = {}

# Start pusher server
EM.run {

  EM.tick_loop do
    zmq_message = ''
    puller.recv_string(zmq_message, ZMQ::DONTWAIT)
    if zmq_message != ''

      # Handle different ZMQ push messages here

      parsed_message = JSON.parse(zmq_message)
      begin
        case parsed_message['event']

          # Handles when user's online services are being sent
          when 'services_online_update'

            parsed_message['services_online'].each do |service_data|
              services_online[service_data['id'].to_s] = service_data

              # Todo: Add connection id to service
            end

          # Handles when service status is updated
          when 'update_service_status'

            service_id = parsed_message['service']['id']
            is_active = parsed_message['service']['is_active'].to_boolean

            if is_active
              services_online[service_id.to_s] = parsed_message['service']
            else
              if services_online.has_key? service_id.to_s
                services_online.delete service_id.to_s
              end
            end

          # Handles sending a takt to a service
          when 'update_takts_signal'

            recipient_id = parsed_message['recipient_id']
            if services_online.has_key?(recipient_id.to_s) && clients.count > 0

              # Send message to corresponding web socket connection of service user
              service_user_id = services_online[recipient_id.to_s]['user_id']

              unless clients.select {|key,value| value[:user_id] == service_user_id}.nil?
                service_client_connection = clients.select {|key,value| value[:user_id] == service_user_id}.first[1][:conn]
                service_client_connection.send ({task: 'update_takts_signal', service_id: recipient_id, time: Time.now.utc.to_i}).to_json
              end
            end

          else
            # Ignore message
        end
      rescue Exception => ex
        puts 'Message error: ' << ex.message
      end
    end
  end

  # Update services online
  EventMachine::PeriodicTimer.new(4) do
    write_online_services_task = proc do
      target = open('data/online_services.json', 'w')
      target.truncate(0)
      target.write(services_online.to_json)
      target.close
    end

    EM.defer(write_online_services_task)
  end

  EM::WebSocket.run(:host => "127.0.0.1", :port => 5052) do |conn|

    # For a new connection initialize setup of client
    conn.onopen do
      client_id = conn.signature.to_s
      clients[client_id] = {conn: conn, status: :initializing}
      conn_data = {task: 'connect', connection_id: client_id}.to_json
      conn.send conn_data
    end

    conn.onclose do

      # Delete services from online services and then delete the client
      if clients.has_key? conn.signature.to_s

        unless clients[conn.signature.to_s][:services_online].nil?
          clients[conn.signature.to_s][:services_online].collect do |service|
            services_online.delete(service['id']) if services_online.has_key? service['id']
          end
        end

        # Delete client
        clients.delete(conn.signature.to_s) if clients.has_key? conn.signature.to_s
      end
    end

    conn.onmessage do |msg|
      # Handle different types of messages from client
      data = JSON.parse(msg)

      if clients.has_key? data['conn_id']

        target_client = clients[data['conn_id']]

        task = data['task']
        case task

          # The providing_info task populates the client with information regarding services online and ect.
          when 'providing_info'

            target_client[:user_id] = data['user_id']

            # Add the client id to online services for the user
            unless data['user_id'] == 0
              services_online.each do |key, online_service|
                if online_service['user_id'].to_s == data['user_id'].to_s
                  services_online[key]['conn_id'] = conn.signature.to_s
                end
              end
            end

            target_client[:status] = :ready
            response = {task: 'make_ready'}.to_json
            target_client[:conn].send response

          else
            # Ignore message

        end
      end
    end

  end

  puts "Takt Server started and listening on port 5052...\n"
}