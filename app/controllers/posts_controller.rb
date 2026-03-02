class PostsController < ApplicationController
  skip_before_action :require_authentication, only: [ :index ] # 投稿一覧画面は誰でも見れるようにする

  def index
    @posts = Post.all.order(created_at: :desc)
  end

  def new
    @post = current_user.posts.build
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      redirect_to root_path, notice: "アニメを記録しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def watched
    @posts = Post.watched
    render :index #"watched"ようのビューファイルを作る代わりに、indexビューを使い回す
  end

  def want_to_watched
    @posts = Post.want_to_watched
    render :index
  end

  private

  def post_params
    params.require(:post).permit(:title, :content, :rating, :annict_id, :image_url, :status)
  end
end
