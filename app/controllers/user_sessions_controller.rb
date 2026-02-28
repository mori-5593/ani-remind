class UserSessionsController < ApplicationController
  allow_unauthenticated_access only: %i[ new create ] #未ログイン時にアクセス可能
  def new
  end

  def create
    user = User.authenticate_by(email_address: params[:email_address], password: params[:password])
    if user
      start_new_session_for user
      redirect_to root_path, notice: "ログインしました"
    else
      flash.now[:alert] = "メールアドレスまたはパスワードが正しくありません"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    terminate_session
    redirect_to root_path, notice: "ログアウトしました"
  end
end
