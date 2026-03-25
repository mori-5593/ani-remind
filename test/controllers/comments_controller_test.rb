require "test_helper"

class CommentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @post = posts(:one) # コメントがつく記事
    @user = users(:one) # コメント投稿者
    sign_in_as(@user) # ログイン状態にする
  end

  # コメント投稿のテスト
  test "should create comment" do
    @user = users(:one) # テスト用のユーザー準備

    assert_difference("Comment.count", 1) do
      post post_comments_url(@post), params: { comment: { content: "テストコメント" } }
    end
    assert_redirected_to post_url(@post)
  end

  # コメント削除のテスト
  test "should destroy comment" do
    @comment = comments(:one) # 消したいコメントを取得
    @post = @comment.post # そのコメントが紐づいている記事を取得

    assert_difference("Comment.count", -1) do
      # ルーティングに合わせて@post, @commentの両方を引数に入れる
      delete post_comment_url(@post, @comment)
    end
    assert_redirected_to post_url(@post)
  end
end
