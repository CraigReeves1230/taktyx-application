class ActivationEmailJob < ActiveJob::Base
  queue_as :default

  def perform(user, token)
    @user = user
    @token = token
    UserMailer.activation_email(@user, @token).deliver_later
  end
end
