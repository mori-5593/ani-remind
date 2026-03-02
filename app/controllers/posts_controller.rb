class PostsController < ApplicationController
  skip_before_action :require_authentication, only: [ :index ] # 投稿一覧画面は誰でも見れるようにする

  def index
    @posts = Post.all.order(created_at: :desc)
    @page_title = "投稿一覧"
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

  def show
    @post = Post.find(params[:id])
  end

  def watched
    # ステータスが「見た（０）」の投稿だけ取得
    @posts = current_user.posts.watched
    @page_title = "みた一覧"
    render :index
  end

  def want_to_watch
    # ステータスが「見たい（１）」の投稿だけ取得
    @posts = current_user.posts.want_to_watch
    @page_title = "みたい一覧"
    render :index
  end

  private

  def post_params
    params.require(:post).permit(:title, :content, :rating, :annict_id, :image_url, :status)
  end
end
