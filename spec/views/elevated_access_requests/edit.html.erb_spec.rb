require 'rails_helper'

RSpec.describe "elevated_access_requests/edit", type: :view do
  let(:elevated_access_request) {
    ElevatedAccessRequest.create!(
      user: nil,
      access_point: nil,
      reason: "MyText",
      status: "MyString"
    )
  }

  before(:each) do
    assign(:elevated_access_request, elevated_access_request)
  end

  it "renders the edit elevated_access_request form" do
    render

    assert_select "form[action=?][method=?]", elevated_access_request_path(elevated_access_request), "post" do

      assert_select "input[name=?]", "elevated_access_request[user_id]"

      assert_select "input[name=?]", "elevated_access_request[access_point_id]"

      assert_select "textarea[name=?]", "elevated_access_request[reason]"

      assert_select "input[name=?]", "elevated_access_request[status]"
    end
  end
end
