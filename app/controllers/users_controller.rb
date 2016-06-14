# UsersController
#
# @author Christopher Reeves
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

    user = User.create(params.require(:user).permit(
        :first_name,
        :last_name,
        :screen_name,
        :email,
        :password,
        :password_confirmation
    ))

    # Validation failed, send errors back to page
    if !user.valid?
      render json: {:has_errors => true, :data => user.errors}
    else
      # Save session and return user information
      session[:user_id] = user.id
      render json: {:has_errors => false, :data => user}
    end
  end

end
