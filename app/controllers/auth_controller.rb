# AuthController
#
# @author Christopher Reeves
# @author Craig Reeves
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
        set_current_user(user)

        # Remember user if the checkbox is checked
        if params[:auth][:remember]
          remember(user)
        else
          forget(user)
        end

        # Redirect to previous page
        redirect_path = '/'
        if params.has_key?('whence')
          redirect_path = URI.decode_www_form_component(params['whence'])
        end

        # Authentication success
        render json: {:has_errors => false, :data => user, :redirect_path => redirect_path}
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
    forget(@current_user)
    session.clear
    redirect_to home_path
  end

  # Remembers a user in a persistent session. Stores both the id and the token in cookies.
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
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
