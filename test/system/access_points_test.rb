require "application_system_test_case"

class AccessPointsTest < ApplicationSystemTestCase
  setup do
    @access_point = access_points(:one)
  end

  test "visiting the index" do
    visit access_points_url
    assert_selector "h1", text: "Access points"
  end

  test "should create access point" do
    visit access_points_url
    click_on "New access point"

    fill_in "Access level", with: @access_point.access_level
    fill_in "Description", with: @access_point.description
    fill_in "Location", with: @access_point.location
    check "Status" if @access_point.status
    click_on "Create Access point"

    assert_text "Access point was successfully created"
    click_on "Back"
  end

  test "should update Access point" do
    visit access_point_url(@access_point)
    click_on "Edit this access point", match: :first

    fill_in "Access level", with: @access_point.access_level
    fill_in "Description", with: @access_point.description
    fill_in "Location", with: @access_point.location
    check "Status" if @access_point.status
    click_on "Update Access point"

    assert_text "Access point was successfully updated"
    click_on "Back"
  end

  test "should destroy Access point" do
    visit access_point_url(@access_point)
    click_on "Destroy this access point", match: :first

    assert_text "Access point was successfully destroyed"
  end
end
