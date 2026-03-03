class PostsController < ApplicationController
  skip_before_action :require_authentication, only: [ :index ] # 投稿一覧画面は誰でも見れるようにする
  before_action :ensure_current_user, only: [ :edit, :update, :destroy ]

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

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    if @post.update(post_params)
      redirect_to @post, notice: "投稿を更新しました"
    else
      render :edit, status: unprocessable_entity
    end
  end

  def destroy
    @post.destroy!
    redirect_to root_path, notice: "投稿を削除しました"
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

  def search
    # サービスオブジェクトを使って検索結果を取得
    results = AnnictApiClient.new.search_works(params[:keyword])
    # 結果をJSON形式でブラウザに返す
    render json: results
  end

  private

  def post_params
    params.require(:post).permit(:title, :content, :rating, :annict_id, :image_url, :status)
  end

  def ensure_current_user
    @post = Post.find(params[:id])
    unless @post.user_id == current_user.id
      redirect_to posts_path, alert: "他人の投稿は編集できません"
    end
  end
end
