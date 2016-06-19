module Authentication

  # Get auth user in view
  def check_for_current_user
    # Get the currently logged in user in session
    if session.has_key? :user_id
      @current_user ||= User.find_by_id(session[:user_id])
      # If no session, look for a remember cookie
    elsif cookies.signed[:user_id]
      temp_user = User.find_by_id(cookies.signed[:user_id])
      # Check remember token cookie against the remember digest
      if temp_user && temp_user.token_authenticated?("remember", cookies[:remember_token])
        @current_user = temp_user
      end
    end
  end

  # Determines if a user is the current user
  def current_user?(user)
    check_for_current_user == user
  end

  # Determines if a user is logged in
  def logged_in?
    !check_for_current_user.nil?
  end

  # Require logged in user
  def require_logged_in
    unless logged_in?
      whence = URI.encode_www_form_component(request.env['REQUEST_PATH'])
      redirect_to login_url({:whence => whence})
    end
  end

  # Logs a user in automatically
  def set_current_user(user)
    session[:user_id] = user.id
  end

  # Verifies if current user has been activated. Used for before actions that require activation
  def verify_activation
    if !check_for_current_user.nil? && !check_for_current_user.active?
      render 'activations/email_act_remind'
    end
  end
end