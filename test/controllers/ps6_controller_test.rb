require 'test_helper'

class Ps6ControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get ps6_index_url
    assert_response :success
  end

end
