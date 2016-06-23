# UsersController
#
# @author Christopher Reeves
# @author Craig Reeves
# @copyright (c) 2016 by Taktyx

#
# Manages various tasks involving users and user accounts
#
class UsersController < ApplicationController

  # Serves the page where users enter information to register for an account
  def register

  end

  # Save new user to database
  def do_save_user

    user = User.new({
        first_name: params[:user][:first_name] || '',
        last_name: params[:user][:last_name] || '',
        screen_name: params[:user][:screen_name] || '',
        email: params[:user][:email] || '',
        password: params[:user][:password] || '',
        password_confirmation: params[:user][:password_confirmation] || ''
                    })

    # Validation failed, send errors back to page
    if !user.valid?
      flash[:danger] = user.errors
      render json: {:has_errors => true, :data => user.errors}
    else
      # Send activation email
      user.send_activation_email

      # Log user in and return user information
      flash[:success] = "Account created! To activate your account, please follow the instructions
                          sent to the email you provided upon sign-up."
      set_current_user(user)
      render json: {:has_errors => false, :data => user}
    end
  end

  def resend_activation
    if logged_in?
      @current_user.send_activation_email
      flash[:success] = "Account created! To activate your account, please follow the instructions
                          sent to the email you provided upon sign-up."
      render 'home/index'
    else
      redirect_to home_url
    end
  end

end
