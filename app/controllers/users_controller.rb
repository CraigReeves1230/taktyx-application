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

  def show
    @user = User.find_by id: params[:id]
  end

  def update
    @user = User.find_by_email params[:user][:email]
    @user.first_name = params[:user][:first_name]
    @user.last_name = params[:user][:last_name]
    @user.screen_name = params[:user][:screen_name]
    if @user.update_attribute(:first_name, @user.first_name) && @user.update_attribute(:last_name, @user.last_name) && @user.update_attribute(:screen_name, @user.screen_name)
      flash.now[:success] = "Account has been updated!"
      render 'show'
    else
      flash.now[:danger] = "There was a problem updating your account."
      render 'show'
    end
  end

  def edit
    @user = User.find_by id: params[:id]
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
