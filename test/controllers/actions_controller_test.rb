require "test_helper"

class ActionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(
      email_address: "test_#{rand(1000)}@example.com",
      password: "password",
      password_confirmation: "password",
      name: "Test User"
    )

    post login_path, params: {
      email_address: @user.email_address,
      password: "password"
    }

    @action = @user.actions.create!(
      annict_id: 1,
      action_type: "want_to_watch",
      title: "テストアニメ",
      image_url: "https://example.com/image.jpg",
      user: @user
    )
  end

  test "should get create" do
    assert_difference("Action.count", 1) do
    post actions_url, params: {
      my_action: {
        annict_id: 2,
        action_type: "watched",
        title: "テストアニメ2",
        image_url: "https://example.com/image2.jpg"
      }
    }
    end

    assert_response :redirect
    assert_redirected_to posts_path
  end

  test "should update action" do
    patch action_url(@action), params: {
      my_action: {
        annict_id: @action.annict_id,
        title: "更新後タイトル"
      }
    }

    assert_redirected_to posts_path
  end
end
