class ApplicationController < ActionController::Base
  include Authentication
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  helper_method :current_user, :logged_in?

  private

  def login(email, password)
    user = User.authenticate_by(email_address: email, password: password)
    if user
      start_new_session_for user
      return user
    end
    false
  end
  
  def current_user
    # Current.user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def logged_in?
    # Current.user.present?
    current_user.present?
  end

  def start_new_session_for(user)
    session[:user_id] = user.id
  end

  def terminate_session
    session.delete(:user_id)
    @current_user = nil
  end

  # Changes to the importmap will invalidate the etag for HTML responses
  # stale_when_importmap_changes
end
