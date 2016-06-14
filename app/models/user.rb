class User < ActiveRecord::Base

  has_secure_password

  # Validations
  validates :first_name, presence: {message: "Please provide your first name"}
  validates :first_name, format: {with: /[A-z\s\-]+/, message: "Your name can only include alpha characters"}
  validates :last_name, presence: {message: "Please provide your last name"}
  validates :last_name, format: {with: /[A-z\s\-]+/, message: "Your name can only include alpha characters"}
  validates :screen_name, presence: {message: "Please provide a screen name"}
  validates :screen_name, length: {minimum: 5, message: "Your screen name must be at least 5 characters in length."}
  validates :screen_name, format: {with: /[A-z\-\_0-9]+/, message: "Your screen name can only contain alpha-numeric characters"}
  validates :password, confirmation: {message: "The passwords must match"}
  validates :password, length: {minimum: 6, message: "The password must be at least 6 characters in length"}
  validates :password_confirmation, presence: {message: "Please repeat the password to confirm"}
  validates :email, presence: {message: "Please provide your email address."}
  validates :email, format: {with: /[\w\d\.]+\@[\w\.]+\.[\w\d]/, message: "Please provide a valid email address"}
  validates :email, uniqueness: {message: "There is already a user with this email address in our records", case_sensitive: false}

end
