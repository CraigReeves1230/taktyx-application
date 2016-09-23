class UserMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.reset_password.subject
  #
  def reset_password(user, token)
    @user = user
    @user.reset_token = token
    @reset_link = edit_password_reset_url(@user.reset_token, email: @user.email)
    mail to: user.email, subject: "Reset Password"
  end

  def activation_email(user, token)
    @user = user
    @user.activation_token = token
    @act_link = activation_confirm_url(@user.activation_token, email: @user.email)
    mail to: user.email, subject: "Account Activation"
  end

  def delete_email(user, token)
    @user = user
    @user.delete_token = token
    @delete_link = delete_account_url(@user.delete_token, email: @user.email)
    mail to: user.email, subject: "Confirm Delete Account"
  end
end
