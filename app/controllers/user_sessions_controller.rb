class UserSessionsController < ApplicationController
  allow_unauthenticated_access only: %i[ new create ]
  def new
  end

  def create
    if user = login(params[:session][:email_address], params[:session][:password])
      redirect_to root_path, notice: "ログインしました"
    else
      flash.now[:alert] = "メールアドレスまたはパスワードが正しくありません"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    terminate_session
    redirect_to login_path, notice: "ログアウトしました", status: :see_other
  end
end
