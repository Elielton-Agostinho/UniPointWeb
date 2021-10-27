require "test_helper"

class ForgetAccountControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get forget_account_index_url
    assert_response :success
  end
end
