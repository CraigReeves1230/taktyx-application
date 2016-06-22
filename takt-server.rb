require 'eventmachine'
require 'em-websocket'
require 'json'
require 'byebug'

clients = {}
services_online = {}

# Start pusher server
EM.run {

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
      puts "Connection opening - id: " << conn.signature.to_s << "\n"
    end

    conn.onclose do
      
      puts "Connection closing - id: " << conn.signature.to_s << "\n"

      # Delete services from online services and then delete the client
      if clients.has_key? conn.signature.to_s
        puts "Deleting services online"

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
            target_client[:services_online] = data['data']['active_services']

            operation = proc do
              puts "Data is being fetched for " << data['conn_id'] << "\n"

              # Add services to collection of online services
              target_client[:services_online].each do |service|
                services_online[service['id']] = service
              end

            end

            callback = proc do |res|
              puts "Data has been retrieved for " << data['conn_id'] << "\n"
              clients[data['conn_id']][:status] = :ready

              response = {task: 'make_ready'}.to_json
              clients[data['conn_id']][:conn].send response

              # Print out online services to screen
              services_online.each {|service_id, service| puts "Service #{service_id}: #{service['name']}\n" }
              puts "Clients online: " << clients.count.to_s << "\n"
            end

            EM.defer(operation, callback)

          else
            # Ignore message

        end
      end
    end

  end

  puts "Takt Server started and listening on port 5052...\n"
}