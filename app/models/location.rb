class Location < ActiveRecord::Base

  # Associations
  has_one :address

  # Create location from address lines
  def self.create_from_address_lines(attributes)

    return_val = {}
    longitude = 0
    latitude = 0

    begin

      # Perform geo IP lookup to get longitude and latitude coordinates
      api_endpoint = "http://maps.google.com/maps/api/geocode/json"
      address_string = ''
      address_string << attributes[:line_1] << ',' << attributes[:city] << ',' << attributes[:zip_code]

      # Connect
      connection_string = URI.encode(api_endpoint << '?sensor=false&address=' << address_string)
      http_response = HTTParty.get(connection_string, timeout: 5)

      if http_response['status'] == 'OK'
        longitude = Float http_response['results'][0]['geometry']['location']['lng']
        latitude = Float http_response['results'][0]['geometry']['location']['lat']
        return_val = {:long => longitude, :lat => latitude}
      else
        return_val = {:has_error => true, :message => 'We cannot find a geological location for the address entered. Please ensure the address entered is correct.'}
      end

    rescue Net::ReadTimeout

      # The connection took too long
      return_val = {:has_error => true, :message => 'Timeout on connection to location service.'}
    end

    return_val
  end
end
