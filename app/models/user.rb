class User < ActiveRecord::Base

  # Associations
  has_many :services, dependent: :destroy
  has_many :photos, dependent: :destroy

  # Virtual attributes
  attr_accessor :remember_token, :reset_token, :activation_token, :delete_token

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

  # Emails a user their password reset information
  def email_password_reset_link
    UserMailer.reset_password(self).deliver_now
  end

  # Emails a user their activation email
  def send_activation_email
    self.activation_token = User.create_token
    self.update_attribute(:activation_digest, User.create_digest(self.activation_token))
    UserMailer.activation_email(self).deliver_now
  end

  # Returns true if the user's reset password link has NOT expired (2 hours)
  def delete_link_still_fresh?
    self.delete_sent_at > 10.minutes.ago
  end

  # Returns true if the user's reset password link has NOT expired (2 hours)
  def reset_link_still_fresh?
    self.reset_sent_at > 2.hours.ago
  end

  # Returns all of the user's photos
  def all_photos
    self.photos.all
  end

  # Returns true if user is activated
  def active?
    self.status == "active"
  end

  # Remembers a user by saving the remember token in the remember digest
  def remember
    self.remember_token = User.create_token  # create new token and assign it to remember token
    # update the remember_digest in the database with a B-Crypt hash digest of the remember token
    update_attribute(:remember_digest, User.create_digest(remember_token))
  end

  # Sends an email to user to confirm deleting your account
  def send_delete_email
    self.delete_token = User.create_token
    update_attribute(:delete_digest, User.create_digest(delete_token))
    update_attribute(:delete_sent_at, Time.zone.now)
    UserMailer.delete_email(self).deliver_now
  end

  # Forgets a user by removing the remember token in the remember digest
  def forget
    update_attribute(:remember_digest, nil)
  end

end
