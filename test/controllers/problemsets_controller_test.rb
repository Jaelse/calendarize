require 'test_helper'

class ProblemsetsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get problemsets_index_url
    assert_response :success
  end

end
