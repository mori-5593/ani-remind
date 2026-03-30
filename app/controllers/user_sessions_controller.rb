class UserSessionsController < ApplicationController
  allow_unauthenticated_access only: %i[ new create oauth ] # 未ログイン時にアクセス可能
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
      # emailがある場合のみ既存ユーザーと紐付け
      if auth.info.email.present?
        user = User.find_by(email_address: auth.info.email)
      end

      # それでもいなければ新規作成
      if user.nil?
        user = User.new(
          provider: auth.provider,
          uid: auth.uid,
          email_address: auth.info.email || "#{auth.uid}@example.com",
          name: auth.info.name,
          password: SecureRandom.hex(10)
        )
      else
        # 既存ユーザーにprovider情報を紐付け
        user.update(
          provider: auth.provider,
          uid: auth.uid
        )
      end

      user.save!
    end

    if user.persisted?
      start_new_session_for(user)
      provider_name = case auth.provider
                      when "google_oauth2" then "Googleアカウント"
                      when "line" then "LINEアカウント"
                      else auth.provider
                      end
      redirect_to posts_path, notice: "#{provider_name}でログインしました"
    else
      redirect_to login_path, alert: "ログインに失敗しました"
    end
  end
end
