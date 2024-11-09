require 'rails_helper'

RSpec.describe "elevated_access_requests/new", type: :view do
  before(:each) do
    assign(:elevated_access_request, ElevatedAccessRequest.new(
      user: nil,
      access_point: nil,
      reason: "MyText",
      status: "MyString"
    ))
  end

  it "renders new elevated_access_request form" do
    render

    assert_select "form[action=?][method=?]", elevated_access_requests_path, "post" do

      assert_select "input[name=?]", "elevated_access_request[user_id]"

      assert_select "input[name=?]", "elevated_access_request[access_point_id]"

      assert_select "textarea[name=?]", "elevated_access_request[reason]"

      assert_select "input[name=?]", "elevated_access_request[status]"
    end
  end
end
