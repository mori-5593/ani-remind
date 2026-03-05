# 新規登録
class UsersController < ApplicationController
  allow_unauthenticated_access only: %i[ new create]
  before_action :require_authentication

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      start_new_session_for(@user)
      redirect_to root_path, notice: "ユーザー登録が完了しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @user = User.find(params[:id])
    @posts = @user.posts.order(created_at: :desc)
  end

  def edit
    @user = User.find(params[:id])
    redirect_to root_path, alert: "権限がありません" unless @user == current_user
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to user_path(@user), notice: "プロフィールを更新しました"
    else
      render :edit, status: unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email_address, :password, :password_confirmation, :introduction)
  end
end
