require "test_helper"

class DashboardAlunoControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get dashboard_aluno_index_url
    assert_response :success
  end
end
