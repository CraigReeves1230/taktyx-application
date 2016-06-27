class Address < ActiveRecord::Base

  # Associations
  has_one :location, as: :locationable
  belongs_to :addressable, polymorphic: true

  # Validations
  validates :line_1, presence: {message: "The address requires line 1"}
  validates :city, presence: {message: "The city is required for the address"}
  validates :zip_code, presence: {message: "The zip code is required for the address"}
  validates :zip_code, format: {with: /[0-9\-]+/, message: "Please use numbers only for the zipcode"}

end
