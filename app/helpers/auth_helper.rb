module AuthHelper

  # Determines if a user is logged in
  def logged_in?
    !@current_user.nil?
  end

end
