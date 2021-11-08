require "test_helper"

class ProfessorControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get professor_index_url
    assert_response :success
  end
end
