class UserMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.reset_password.subject
  #
  def reset_password(user)
    @user = user
    @reset_link = edit_password_reset_url(@user.reset_token, email: @user.email)
    mail to: user.email, subject: "Reset Password"
  end

  def activation_email(user)
    @user = user
    @act_link = activation_confirm_url(@user.activation_token, email: @user.email)
    mail to: user.email, subject: "Account Activation"
  end
end
