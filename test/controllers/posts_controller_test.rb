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

  test "should get create" do
    assert_difference("Post.count") do
      post posts_url, params: { post: { title: "Test Title", rating: 3, status: "watched", content: "test" } }
    end

    assert_redirected_to root_url # 投稿後のリダイレクト先
  end
end
