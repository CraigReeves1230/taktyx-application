class ActivationsController < ApplicationController
  def confirm
    @user = User.find_by_email(params[:email])
    if @user
      @token = params[:id]
      if @user.token_authenticated?("activation", @token)
        @user.update_attribute(:status, "active")
        @user.update_attribute(:activation_digest, nil)
        log_in(@user)
        flash.now[:success] = "Your account has now been activated!"
        render 'home/index'
      elsif @user.active?
        flash.now[:info] = "Your account is already active."
        render 'home/index'
      else
        flash.now[:danger] = "There was a problem activating your account. Please contact us at support@taktyx.com for assistance."
        render 'home/index'
      end
    else
      flash.now[:danger] = "Not a valid user account. Please contact us at support@taktyx.com for assistance"
      render 'home/index'
    end
  end
end
