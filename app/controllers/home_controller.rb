class HomeController < ApplicationController
  skip_before_action :require_authentication, only: [ :index ] # 投稿一覧画面は誰でも見れるようにする

  def index
  end
end
