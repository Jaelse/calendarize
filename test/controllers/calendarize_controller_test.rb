require 'test_helper'

class CalendarizeControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get calendarize_index_url
    assert_response :success
  end

end
