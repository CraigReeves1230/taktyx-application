# AuthController
#
# @author Christopher Reeves
# @copyright (c) 2016 by Taktyx

#
# This controller handles all actions regarding
# signing in and out users and password recovery
#
class AuthController < ApplicationController

  # Log user in
  def login
  end

  # Perform authentication
  def do_login

    # Validate form
    errors = validate_input params
    if !errors

      # Locate and authenticate user
      user = User.find_by_email params[:auth][:email]
      if user && user.authenticate(params[:auth][:password])
        # Log user in
        session[:user_id] = user.id
        render json: {:has_errors => false, :data => user}
      else
        # Authentication failed
        render json: {:has_errors => true, :data => {:email => ["Email and or password does not match our records"]}}
      end
    else
      render json: {:has_errors => true, :data => errors}
    end
  end

  # Validate input
  def validate_input(values)

    login_form = LoginForm.new(values[:auth])

    if !login_form.valid?
      # Return error messages
      login_form.errors
    else
      # No errors
      false
    end
  end

  # Log user out
  def logout

    # Delete the session to log the user out
    session.clear
    redirect_to :back
  end
end

#
# Represents the login form
# We will use this as a helper class to validate the login form
#
class LoginForm < OpenStruct
  include ActiveModel::Validations
  validates :email, presence: {message: "Please provide the email address to your account"}
  validates :password, presence: {message: "Please provide the password to your account"}
end
