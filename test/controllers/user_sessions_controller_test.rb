require "test_helper"

class UserSessionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(
      email_address: "test_#{rand(1000)}@example.com",
      password: "password",
      password_confirmation: "password",
      name: "Test User"
    )
  end

  test "should get new" do
    get login_url
    assert_response :success
  end

  test "should login (create session)" do
    post login_url, params: { session: { email_address: @user.email_address, password: "password" } }

    assert_redirected_to root_url
    assert_equal @user.id, session[:user_id]
  end

  test "should logout (destroy session)" do
    delete "/logout"

    assert_redirected_to login_url
    assert_nil session[:user_id]
  end
end
