module AuthHelper

  # Determines if a user is logged in
  def logged_in?
    !@auth_user.nil?
  end

end
