class User < ActiveRecord::Base

  # Associations
  has_many :services

  # Virtual attributes
  attr_accessor :remember_token

  # Password and password confirmation authentication (for Bcrypt)
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
  validates :email, email: {message: "Please provide a valid email address"}
  validates :email, uniqueness: {message: "There is already a user with this email address in our records", case_sensitive: false}

  # Function to create tokens for remembering and email activation
  def User.create_token
    SecureRandom.urlsafe_base64
  end

  # Creates a hash digest of a given string. This is a class function. No need to understand this code.
  def User.create_digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
        BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # Returns true if the given token matches the remember or email activation digest in the database. The first parameter is a
  # string that determines the type of token it is. The second is the token itself.
  def token_authenticated?(attribute = "remember", token)
    # determine what kind of token it is
    digest = send("#{attribute}_digest")
    # Prevent problems with logging out in one browser but staying logged in in another
    return false if digest.nil?
    # See if token matches digest
    BCrypt::Password.new(digest).is_password?(token)
  end

  # Remembers a user by saving the remember token in the remember digest
  def remember
    self.remember_token = User.create_token  # create new token and assign it to remember token
    # update the remember_digest in the database with a B-Crypt hash digest of the remember token
    update_attribute(:remember_digest, User.create_digest(remember_token))
  end

  # Forgets a user by removing the remember token in the remember digest
  def forget
    update_attribute(:remember_digest, nil)
  end

end
