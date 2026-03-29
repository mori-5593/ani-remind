class PagesController < ApplicationController
  skip_before_action :require_authentication, only: [:privacy, :terms]

  def privacy
  end

  def terms
  end
end
