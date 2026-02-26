class PostsController < ApplicationController
  included Authentication

  def current_user
    Current.user
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

  private

  def post_params
    params.require(:post).permit(:title, :content, :rating, :annict_id, :image_url, :status)
  end
end
