# The TaktServer
#
# The Takt Server is a seperate socket server that manages client connections
# and push notifications regarding services online and messages to user services
# @author Christopher Reeves
# @copyright (c) 2016 by Taktyx

require 'eventmachine'
require 'em-websocket'
require 'json'
require 'ffi-rzmq'
require 'to_boolean'

class TaktServer

  # Start ZMQ messaging server
  def initialize
    @clients_online = {}
    @services_online = {}
    @zmq_context = ZMQ::Context.new
    @zmq_pull = @zmq_context.socket(ZMQ::PULL)
    @zmq_pull.bind("tcp://*:5050")
  end

  # Starts the server
  def start

    # Start the server loop
    EM.run {

      # ---------------------------------------------------------------------
      # Server Tick Loop
      # ---------------------------------------------------------------------
      # Every tick of the server loop, check ZMQ for various messages
      # and handle them accordingly
      EM.tick_loop do
        handle_incoming_zmq_messages
      end

      # ---------------------------------------------------------------------
      # Server Periodic Timer
      # ---------------------------------------------------------------------
      # Every 4 seconds, the data regarding the current user services
      # online is saved to a file. This is not ideal and we will later save
      # this information to an in-memory store like Memcached or Redis
      EventMachine::PeriodicTimer.new(4) do
        persist_services_online_data
      end

      # ---------------------------------------------------------------------
      # WebSocket Server
      # ---------------------------------------------------------------------
      # The websocket server listens on port 5052 for incoming websocket connections.
      # The connections are saved in memory along with a unique connection id so that
      # we can push messages to a connection at anytime.
      EM::WebSocket.run(:host => "127.0.0.1", :port => 5052) do |ws_connection|

        #
        # For a new connection initialize setup of client
        #
        ws_connection.onopen do

          connection_id = ws_connection.signature.to_s
          @clients_online[connection_id] = {conn: ws_connection, status: :initializing}
          conn_data = {task: 'connect', connection_id: connection_id}.to_json
          ws_connection.send conn_data
        end

        #
        # Handle user dropping offline
        #
        ws_connection.onclose do

          # Delete services from online services and then delete the client
          if @clients_online.has_key? ws_connection.signature.to_s

            unless @clients_online[ws_connection.signature.to_s][:@services_online].nil?
              @clients_online[ws_connection.signature.to_s][:@services_online].collect do |service|
                @services_online.delete(service['id']) if @services_online.has_key? service['id']
              end
            end

            # Delete client
            @clients_online.delete(ws_connection.signature.to_s) if @clients_online.has_key? ws_connection.signature.to_s
          end
        end

        #
        # Handle various message that come in from the web socket
        #
        ws_connection.onmessage do |msg|

          data = JSON.parse(msg)
          if @clients_online.has_key? data['conn_id']

            # The connection that the message is coming from
            messaging_client = @clients_online[data['conn_id']]
            case data['task']

              # The providing_info task runs when a user lands on a page
              # and is used to check what services they have active and add it to the online_services
              when 'providing_info'

                messaging_client[:user_id] = data['user_id']

                # Add the client id to online services for the user
                unless data['user_id'] == 0
                  @services_online.each do |key, online_service|
                    if online_service['user_id'].to_s == data['user_id'].to_s
                      @services_online[key]['conn_id'] = ws_connection.signature.to_s
                    end
                  end
                end

                # Once the client's information's provided, they're in ready status
                messaging_client[:status] = :ready
                json_response = {task: 'make_ready'}.to_json
                messaging_client[:conn].send json_response

              else
                # Ignore message

            end
          end
        end

      end

      puts "Takt Server started and listening on port 5052...\n"
    }
  end

  # Handles various types of pushed messages from ZMQ
  def handle_incoming_zmq_messages

    incoming_payload = ''
    @zmq_pull.recv_string(incoming_payload, ZMQ::DONTWAIT) # Don't block and wait for a message
    unless incoming_payload.empty?

      # Handle different ZMQ push messages that come in from Rails
      parsed_message = JSON.parse(incoming_payload)
      begin
        case parsed_message['event']

          # Handles when user's online services are being sent
          when 'services_online_update'

            parsed_message['services_online'].each do |service_data|
              @services_online[service_data['id'].to_s] = service_data

              # Todo: I need to add the connection id to the service payload
            end

          # Handles when service status is updated
          when 'update_service_status'

            service_id = parsed_message['service']['id']
            service_is_active = parsed_message['service']['is_active'].to_boolean

            if service_is_active
              @services_online[service_id.to_s] = parsed_message['service']
            else
              if @services_online.has_key? service_id.to_s
                @services_online.delete service_id.to_s
              end
            end

          # Handles sending a message to a user service
          when 'update_takts_signal'

            recipient_id = parsed_message['recipient_id']
            if @services_online.has_key?(recipient_id.to_s) && @clients_online.count > 0

              # Send message to corresponding web socket connection of service user
              service_user_id = @services_online[recipient_id.to_s]['user_id']

              unless @clients_online.select {|key,value| value[:user_id] == service_user_id}.nil?
                service_client_connection = @clients_online.select {|key,value| value[:user_id] == service_user_id}.first[1][:conn]
                service_client_connection.send ({task: 'update_takts_signal', service_id: recipient_id, time: Time.now.utc.to_i}).to_json
              end
            end

          else
            # Ignore message
        end
      rescue Exception => ex
        # TODO: This should be logged to a file
        puts 'Message error: ' << ex.message
      end
    end
  end

  # Saves information regarding the current user services online
  # to storage
  def persist_services_online_data

    # Because file IO is a blocking process, put this on another thread
    write_online_services_task = proc do
      target = open('data/online_services.json', 'w')
      target.truncate(0)
      target.write(@services_online.to_json)
      target.close
    end

    write_online_error = proc do
      puts "Error saving data for online services..."
    end

    EM.defer(write_online_services_task, nil, write_online_error)
  end
end

# Start server
server = TaktServer.new
server.start
