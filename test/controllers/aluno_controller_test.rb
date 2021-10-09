require "test_helper"

class AlunoControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get aluno_index_url
    assert_response :success
  end
end
