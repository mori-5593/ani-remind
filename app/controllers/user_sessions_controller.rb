class UserSessionsController < ApplicationController
  allow_unauthenticated_access only: %i[ new create google_auth ] # 未ログイン時にアクセス可能
  def new
  end

  def create
    user = User.authenticate_by(email_address: params[:email_address], password: params[:password])
    if user
      # remember_meにチェックが入っていれば永続クッキーを使用
      start_new_session_for(user, permanent: params[:remember_me] == "1")
      redirect_to posts_path, notice: "ログインしました"
    else
      flash.now[:alert] = "メールアドレスまたはパスワードが正しくありません"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    terminate_session
    redirect_to root_path, notice: "ログアウトしました"
  end

  def google_auth
    auth = request.env["omniauth.auth"]
    user = User.find_or_create_by(email_address: auth.info.email) do |u|
      u.name = auth.info.name
      u.password = SecureRandom.hex(10)
    end

    if user.persisted?
      start_new_session_for(user)
      redirect_to posts_path, notice: "Googleアカウントでログインしました"
    else
      redirect_to login_path, alert: "Googleログインに失敗しました"
    end
  end
end
