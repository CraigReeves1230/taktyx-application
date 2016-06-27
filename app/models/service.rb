class Service < ActiveRecord::Base

  require "fuzzystringmatch"

  # Associations
  has_one :address, as: :addressable
  belongs_to :category
  belongs_to :user
  has_many :messages, foreign_key: :recipient_id
  has_many :photos

  # Validation
  validates :user_id, presence: {message: 'The service requires a user'}
  validates :category_id, presence: {message: 'The service requires a category'}
  validates :description, presence: {message: 'Services are required to have a description'}
  validates :description, length: {minimum: 40, maximum: 300}
  validates :email, presence: {message: 'The service requires an email'}
  validates :email, email: {message: "Please provide a valid email address for your service"}
  validates :name, presence: {message: "Please provide a name for the service"}
  validates_plausible_phone :phone, presence: false

  # Normalize and format phone number
  phony_normalize :phone, default_country_code: 'US'

  # Creates or updates a service
  def create_or_save(service_data, service_user)

    is_update = service_data.has_key?('id') && !(service_data['id'].nil? || service_data['id'] == 0)
    errors = false
    has_errors = false

    # Asynchronously make google API call
    location_hash = {}
    similar_service_exists = false
    exceeds_service_count_max = false
    get_location_thread = Thread.new { location_hash = Location.create_from_address_lines({line_1: service_data[:address_line_1] || '',
                                                                                           city: service_data[:address_city] || '',
                                                                                           zip_code: service_data[:zip_code] || ''}) }

    # Asynchronously check if service already exists
    check_similar_record_thread = Thread.new do
      similar_service_exists = self.check_for_similar_service(service_data, service_user)
    end

    # Async check if user exceeds the amount of allowed services
    if !is_update
      check_service_max_thread = Thread.new do
        exceeds_service_count_max = self.exceeds_service_count_max?(service_user)
      end
    else
      check_service_max_thread = false
    end

    # Begin transaction to save service, corresponding address and location
    self.transaction do
      begin

        # Wait for the location fetching thread to get done
        get_location_thread.join

        # Create address
        if service_data.has_key?('address_id') && !(service_data['address_id'].nil? || service_data['address_id'] == 0)
          address = Address.find_by_id(service_data['address_id'])
        else
          address = Address.new({})
        end

        address.assign_attributes({line_1: service_data[:address_line_1] || '',
                                   line_2: service_data[:address_line_2] || '',
                                   city: service_data[:address_city] || '',
                                   zip_code: service_data[:zip_code] || ''})

        # Create location from Google API to save to address
        raise ActiveRecord::Rollback, location_hash[:message] if location_hash[:has_error]
        address.create_location(location_hash)

        # If an error occurs while saving we will roll back the transaction
        address.save!

        # Create a new service
        assign_attributes({name: service_data[:name],
                           description: service_data[:description],
                           keywords: service_data[:keywords],
                           email: service_data[:email],
                           phone: service_data[:phone],
                           is_sharing_allowed: service_data[:is_sharing_allowed],
                           is_published: service_data[:is_published],
                           are_ratings_allowed: service_data[:are_ratings_allowed],
                           can_receive_takts: service_data[:can_receive_takts]})

        self.category = Category.find_by_id(service_data[:category][:id])
        self.user = service_user
        self.address = address
        self.save!

        # Wait for thread checking service uniqueness to finish so we can see if there is already a record
        check_similar_record_thread.join

        if similar_service_exists
          # Rollback changes
          raise ActiveRecord::Rollback, "You already have a service with a similar name and/or address. Your services must be unique."
        end

        # Wait for thread checking service count max
        check_service_max_thread.join unless is_update
        if exceeds_service_count_max && !is_update
          raise ActiveRecord::Rollback, "You have reached the maximum amount of services you are allowed to have."
        end

      rescue ActiveRecord::RecordInvalid # Catch validation errors

        # Collect error variables
        if !address.valid?
          errors = address.errors
        elsif !self.valid?
          errors = self.errors
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
  def check_for_similar_service(service_data, service_user)

    result = false

    # Find services by user
    services = service_user.services
    services.each do |service|
      unless service_data.has_key?('id') && service.id == service_data['id']
        similar_name_found = false
        similar_address_found = false
        similarity_scorer = FuzzyStringMatch::JaroWinkler.create(:pure)
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
    end

    result
  end

  # Checks to see if the maximum amount of services per user has been reached
  def exceeds_service_count_max?(service_user)
    services_per_user = Rails.configuration.x.business['services_per_user']
    service_count = service_user.services.size

    service_count >= services_per_user
  end
end
