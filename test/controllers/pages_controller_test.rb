require "test_helper"

class PagesControllerTest < ActionDispatch::IntegrationTest
  test "ログインしなくてもプライバシーポリシーに閲覧できる" do
    get privacy_url
    assert_response :success
  end

  test "ログインしなくても利用規約に閲覧できる" do
    get terms_url
    assert_response :success
  end
end
