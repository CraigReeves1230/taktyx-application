module AuthHelper

  # Get auth user in view
  def auth_user
    # Get the currently logged in user
    if session.has_key? :user_id
      @auth_user ||= User.find_by_id(session[:user_id])
    end
  end

  # Determines if a user is the current user
  def auth_user?(user)
    auth_user == user
  end

  # Determines if a user is logged in
  def logged_in?
    auth_user.nil?
  end

  # Another term for auth_user
  def current_user
    auth_user
  end

  # Remembers user in a current session
  def remember(user)
    #remembers a user in a persistent session. Stores both the id and the token in cookies.
    def remember(user)
      user.remember
      cookies.permanent.signed[:user_id] = user.id
      cookies.permanent[:remember_token] = user.remember_token
    end
  end

end
