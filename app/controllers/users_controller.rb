# 新規登録
class UsersController < ApplicationController
  allow_unauthenticated_access only: %i[ new create]
  before_action :require_authentication, except: %i[new create]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      start_new_session_for(@user)
      redirect_to posts_path, notice: "ユーザー登録が完了しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @user = User.find(params[:id])

    case params[:status]
    when nil
      # 「全て」タブ
      posts = @user.posts.order(created_at: :desc)
      actions = @user.actions.want_to_watch.order(created_at: :desc)
      @all_activities = (posts.to_a + actions.to_a).sort_by(&:created_at).reverse
      @pagy, @items = pagy_array(@all_activities, items: 10)
    when "watched"
      # 「みた」タブ
      @q = @user.posts.watched.ransack(params[:q])
      @pagy, @items = pagy(@q.result.order(created_at: :desc))
    when "want_to_watch"
      # 「みたい」タブ
      posts = @user.posts.want_to_watch.order(created_at: :desc)
      actions = @user.actions.want_to_watch.order(created_at: :desc)
      @all_activities = (posts.to_a + actions.to_a).sort_by(&:created_at).reverse
      @pagy, @items = pagy_array(@all_activities, items: 10)
    else
      @q = @user.posts.ransack(params[:q])
      @pagy, @items = pagy(@q.result.order(created_at: :desc))
    end
  end

  def edit
    @user = User.find(params[:id])
    redirect_to posts_path, alert: "権限がありません" unless @user == current_user
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to user_path(@user), notice: "プロフィールを更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email_address, :password, :password_confirmation, :introduction)
  end
end
