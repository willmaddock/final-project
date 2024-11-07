require "test_helper"

class AccessLogsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @access_log = access_logs(:one)
  end

  test "should get index" do
    get access_logs_url
    assert_response :success
  end

  test "should get new" do
    get new_access_log_url
    assert_response :success
  end

  test "should create access_log" do
    assert_difference("AccessLog.count") do
      post access_logs_url, params: { access_log: { access_point_id: @access_log.access_point_id, successful: @access_log.successful, timestamp: @access_log.timestamp, user_id: @access_log.user_id } }
    end

    assert_redirected_to access_log_url(AccessLog.last)
  end

  test "should show access_log" do
    get access_log_url(@access_log)
    assert_response :success
  end

  test "should get edit" do
    get edit_access_log_url(@access_log)
    assert_response :success
  end

  test "should update access_log" do
    patch access_log_url(@access_log), params: { access_log: { access_point_id: @access_log.access_point_id, successful: @access_log.successful, timestamp: @access_log.timestamp, user_id: @access_log.user_id } }
    assert_redirected_to access_log_url(@access_log)
  end

  test "should destroy access_log" do
    assert_difference("AccessLog.count", -1) do
      delete access_log_url(@access_log)
    end

    assert_redirected_to access_logs_url
  end
end
