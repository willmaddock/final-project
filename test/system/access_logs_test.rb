require "application_system_test_case"

class AccessLogsTest < ApplicationSystemTestCase
  setup do
    @access_log = access_logs(:one)
  end

  test "visiting the index" do
    visit access_logs_url
    assert_selector "h1", text: "Access logs"
  end

  test "should create access log" do
    visit access_logs_url
    click_on "New access log"

    fill_in "Access point", with: @access_log.access_point_id
    check "Successful" if @access_log.successful
    fill_in "Timestamp", with: @access_log.timestamp
    fill_in "User", with: @access_log.user_id
    click_on "Create Access log"

    assert_text "Access log was successfully created"
    click_on "Back"
  end

  test "should update Access log" do
    visit access_log_url(@access_log)
    click_on "Edit this access log", match: :first

    fill_in "Access point", with: @access_log.access_point_id
    check "Successful" if @access_log.successful
    fill_in "Timestamp", with: @access_log.timestamp
    fill_in "User", with: @access_log.user_id
    click_on "Update Access log"

    assert_text "Access log was successfully updated"
    click_on "Back"
  end

  test "should destroy Access log" do
    visit access_log_url(@access_log)
    click_on "Destroy this access log", match: :first

    assert_text "Access log was successfully destroyed"
  end
end
