module AuthHelper

  # Get auth user in view
  def auth_user
    # Get the currently logged in user in session
    if session.has_key? :user_id
      @auth_user ||= User.find_by_id(session[:user_id])
    # If no session, look for a remember cookie
    elsif cookies.signed[:user_id]
      temp_user = User.find_by_id(cookies.signed[:user_id])
      # Check remember token cookie against the remember digest
      if temp_user && temp_user.token_authenticated?("remember", cookies[:remember_token])
        @auth_user = temp_user
      end
    end
  end

  # Determines if a user is the current user
  def auth_user?(user)
    !auth_user == user
  end

  # Determines if a user is logged in
  def logged_in?
    !auth_user.nil?
  end

  # Another term for auth_user
  def current_user
    auth_user
  end

  #remembers a user in a persistent session. Stores both the id and the token in cookies.
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  #forgets a user in a persistent session. Removes cookies and the remember_digest
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end
end
