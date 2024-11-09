require 'rails_helper'

RSpec.describe "elevated_access_requests/show", type: :view do
  before(:each) do
    assign(:elevated_access_request, ElevatedAccessRequest.create!(
      user: nil,
      access_point: nil,
      reason: "MyText",
      status: "Status"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/Status/)
  end
end
