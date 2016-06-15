module AuthHelper

  # Get auth user in view
  def auth_user
    # Get the currently logged in user
    if session.has_key? :user_id
      @auth_user ||= User.find(session[:user_id])
    end
  end
end
