require 'rails_helper'

RSpec.describe "elevated_access_requests/index", type: :view do
  before(:each) do
    assign(:elevated_access_requests, [
      ElevatedAccessRequest.create!(
        user: nil,
        access_point: nil,
        reason: "MyText",
        status: "Status"
      ),
      ElevatedAccessRequest.create!(
        user: nil,
        access_point: nil,
        reason: "MyText",
        status: "Status"
      )
    ])
  end

  it "renders a list of elevated_access_requests" do
    render
    cell_selector = 'div>p'
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
    assert_select cell_selector, text: Regexp.new("MyText".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Status".to_s), count: 2
  end
end
