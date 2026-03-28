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

  def oauth
    auth = request.env["omniauth.auth"]

    # provider と uid でユーザーを検索
    user = User.find_by(provider: auth.provider, uid: auth.uid)

    # 見つからない場合はメールアドレスで検索（既存のメール登録ユーザーと連携）
    if user.nil?
      email = auth.info.email

      # emailがない場合（Line対策）
      email ||= "#{auth.uid}@line-user.com"

      user = User.find_or_initialize_by(email_address: email)
      user.provider = auth.provider
      user.uid = auth.uid
      user.name ||= auth.info.name
      # パスワードが未設定（新規登録）の場合のみランダムなパスワードを設定
      user.password = SecureRandom.hex(10) if user.password_digest.nil?
      user.save!
    end

    if user.persisted?
      start_new_session_for(user)
      redirect_to posts_path, notice: "#{auth.provider}でログインしました"
    else
      redirect_to login_path, alert: "ログインに失敗しました"
    end
  end
end
