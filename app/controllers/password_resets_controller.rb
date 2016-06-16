class PasswordResetsController < ApplicationController

  before_action :verify_reset, only: :edit

  def new
  end

  def create
    @email = params[:user][:email]
    @user = User.find_by_email(@email)
    if @user
      @user.reset_token = User.create_token
      @user.update_attribute(:reset_digest, User.create_digest(@user.reset_token))
      @user.update_attribute(:reset_sent_at, Time.zone.now)
      @user.email_password_reset_link
      render 'password_resets/show_info'
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    @email = params[:user][:email]
    @user = User.find_by_email(@email)
    @password = params[:user][:password]
    if @password.empty?
      render 'edit'
    elsif @user.update_attributes(user_params)
      @user.update_attribute(:reset_digest, nil)
      render 'password_resets/success'
    else
      render 'edit'
    end
  end

  private

    def verify_reset
      @user = User.find_by_email(params[:email])
      @reset_token = params[:id]
      unless @user && @user.token_authenticated?("reset", @reset_token) && @user.reset_link_still_fresh?
        redirect_to home_url
      end
    end

    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end

end
