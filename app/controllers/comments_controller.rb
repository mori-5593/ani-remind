class CommentsController < ApplicationController
  def create
    @post = Post.find(params[:id])
    @comment = @post.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      redirect_to edit_post_path, notice: "コメントを投稿しました"
    else
      redirect_to edit_post_path, alert: "投稿に失敗しました"
    end
  end

  def destroy
    comment = Comment.find(params[:id])
    post = comment.post

    if comment.user == current_user
      comment.destroy
      redirect_to edit_post_path, notice: "削除しました"
    else
      redirect_to edit_post_path, alert: "削除できません"
    end
  end
end
