require "test_helper"

class DiariesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get diaries_index_url
    assert_response :success
  end
end
