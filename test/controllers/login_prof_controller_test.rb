require "test_helper"

class LoginProfControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get login_prof_index_url
    assert_response :success
  end
end
