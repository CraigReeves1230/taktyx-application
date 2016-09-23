class ResetPasswordJob < ActiveJob::Base
  queue_as :default

  def perform(user, token)
    @user = user
    @token = token
    UserMailer.reset_password(@user, @token).deliver_later
  end
end
