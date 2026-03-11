require "test_helper"

class PostsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one) # テスト用のユーザーを準備
    sign_in_as(@user) # ログイン状態にする
  end

  test "should get new" do
    get new_post_url
    assert_response :success
  end

  test "should get create and redirect to posts index by default" do
    assert_difference("Post.count") do
      post posts_url, params: { post: { title: "Test Title", rating: 3, status: "watched", content: "test" } }
    end

    assert_redirected_to posts_url # デフォルトは投稿一覧画面
  end

  test "should get create and redirect to mypage when from is mypage" do
    assert_difference("Post.count") do
      post posts_url, params: { post: { title: "Mypage Post", rating: 3, status: "watched", content: "test", from: "mypage" } }
    end

    assert_redirected_to user_url(@user) # マイページへの遷移を確認
  end
end
