require 'test_helper'

class Ps3ControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get ps3_index_url
    assert_response :success
  end

end
