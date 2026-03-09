class ApplicationController < ActionController::Base
  include Authentication
  include Pagy::Backend
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  before_action :resume_session

  helper_method :current_user, :logged_in?

  protected

  # Override pagy to set a global default for items per page
  def pagy(collection, vars = {})
    default_vars = { items: 3 }
    super(collection, default_vars.merge(vars))
  end

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
