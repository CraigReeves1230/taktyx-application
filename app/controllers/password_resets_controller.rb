class PasswordResetsController < ApplicationController

  def new
  end

  def edit
  end

  def update
  end

  def create
    @email = params[:user][:email]
    @user = User.find_by_email(@email)
    if @user
      @user.reset_token = User.create_token
      @user.update_attribute(:reset_digest, User.create_digest(@user.reset_token))
      
      render 'show_info'
    end
  end

  def email_param
    params.require(:user).permit(:email)
  end

end
