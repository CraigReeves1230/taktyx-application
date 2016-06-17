class Address < ActiveRecord::Base

  # Associations
  belongs_to :location
  has_one :service

  # Validations
  validates :line_1, presence: {message: "The address requires line 1"}
  validates :city, presence: {message: "The city is required for the address"}
  validates :zip_code, presence: {message: "The zip code is required for the address"}
  validates :zip_code, format: {with: /[0-9\-]+/, message: "Please use numbers only for the zipcode"}
  validates :location_id, presence: {message: "The address does not have an association location"}

end
