class ApplicationController < ActionController::Base
  include Authentication
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  before_action :resume_session

  helper_method :current_user, :logged_in?

  private

  def current_user
    Current.user
  end

  def logged_in?
    Current.user.present?
  end
  # Changes to the importmap will invalidate the etag for HTML responses
  # stale_when_importmap_changes
end
