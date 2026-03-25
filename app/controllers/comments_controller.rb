class CommentsController < ApplicationController
  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      respond_to do |format|
        format.turbo_stream do
          flash.now[:notice] = "コメントしました"
        end

        format.html do
          redirect_to @post, notice: "コメントしました"
        end
      end
    else
      respond_to do |format|
        format.turbo_stream do
          flash.now[:alert] = "投稿に失敗しました"
        end

        format.html do
          redirect_to @post, alert: "投稿に失敗しました"
        end
      end
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    post = @comment.post

    flash.clear

    if @comment.user == current_user
      @comment.destroy
      flash.now[:notice] = "削除しました"
    else
      flash.now[:alert] = "削除できません"
    end

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to post }
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end
end
