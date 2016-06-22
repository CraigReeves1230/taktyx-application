# ServiceServer module
#
# Contains several functions used for services
# @author Christopher Reeves
# @author Craig Reeves

module ServiceServer

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
end