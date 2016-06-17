class Service < ActiveRecord::Base

  require "fuzzystringmatch"

  # Associations
  belongs_to :address
  belongs_to :category
  belongs_to :user

  # Validation
  validates :user_id, presence: {message: 'The service requires a user'}
  validates :category_id, presence: {message: 'The service requires a category'}
  validates :address_id, presence: {message: 'The service requires an address'}
  validates :description, presence: {message: 'Services are required to have a description'}
  validates :description, length: {minimum: 40, maximum: 300}
  validates :email, presence: {message: 'The service requires an email'}
  validates :email, email: {message: "Please provide a valid email address for your service"}
  validates :name, presence: {message: "Please provide a name for the service"}
  validates_plausible_phone :phone, presence: false

  # Normalize and format phone number
  phony_normalize :phone, default_country_code: 'US'

  # Creates and saves a service
  def self.save_new(service_data, auth_user)

    errors = false
    has_errors = false

    # Asynchronously make google API call
    location_hash = {}
    similar_service_exists = false
    get_location_thread = Thread.new { location_hash = Location.create_from_address_lines({line_1: service_data[:address_line_1], city: service_data[:address_city], zip_code: service_data[:zip_code]}) }

    # Asynchronously check if service already exists
    check_similar_record_thread = Thread.new do
      similar_service_exists = self.check_for_similar_service(service_data, auth_user)
    end

    # Begin transaction to save service, corresponding address and location
    self.transaction do
      begin

        # Wait for the location fetching thread to get done
        get_location_thread.join

        # Create address
        address = Address.new({line_1: service_data[:address_line_1], line_2: service_data[:address_line_2], city: service_data[:address_city], zip_code: service_data[:zip_code]})

        # Create location from Google API to save to address
        raise ActiveRecord::Rollback, location_hash[:message] if location_hash[:has_error]
        address.create_location(location_hash)

        # If an error occurs while saving we will roll back the transaction
        address.save!

        # Create a new service
        service = self.new({name: service_data[:name],
                            description: service_data[:description],
                            keywords: service_data[:keywords],
                            email: service_data[:email],
                            phone: service_data[:phone],
                            is_sharing_allowed: service_data[:is_sharing_allowed],
                            is_published: service_data[:is_published],
                            are_ratings_allowed: service_data[:are_ratings_allowed],
                            can_receive_takts: service_data[:can_receive_takts]})

        service.category = Category.find_by_id(service_data[:category][:id])
        service.user = auth_user
        service.address = address
        service.save!

        # Wait for thread checking service uniqueness to finish so we can see if there is already a record
        check_similar_record_thread.join
        if similar_service_exists
          # Rollback changes
          raise ActiveRecord::Rollback, "You already have a service with a similar name and/or address. Your services must be unique."
        end

      rescue ActiveRecord::RecordInvalid # Catch validation errors

        # Collect error variables
        if !address.valid?
          errors = address.errors
        elsif !service.valid?
          errors = service.errors
        end

        has_errors = true

        # When a rollback exception is raised, all DB saves are undone
        raise ActiveRecord::Rollback

      rescue Exception => ex # Catch any other type of errors

        errors = {:general_error => ex.message}
        has_errors = true

        # When a rollback exception is raised, all previous DB saves are undone
        raise ActiveRecord::Rollback
      end
    end

    {:has_errors => has_errors, :data => errors || service_data}
  end

  # Checks if a similar service exists for the record
  def self.check_for_similar_service(service_data, auth_user)

    result = false

    # Find services by user
    services = auth_user.services
    services.each do |service|
      similar_name_found = false
      similar_address_found = false
      similarity_scorer = FuzzyStringMatch::JaroWinkler.create(:native)
      score = similarity_scorer.getDistance(service_data[:name], service.name)
      if score >= 0.85
        similar_name_found = true
      end

      # If a similar name has been found, check if the address is similar
      if similarity_scorer.getDistance(service_data[:address_line_1], service.address.line_1) >= 0.85
        similar_address_found = true
      end

      # If a similar name and address exist, the record is too similar
      if similar_address_found && similar_name_found
        result = true
        break
      end
    end

    result
  end
end
