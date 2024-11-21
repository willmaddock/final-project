# spec/factories/elevated_access_requests.rb
FactoryBot.define do
  factory :elevated_access_request do
    user
    access_point
    reason { "Need to deliver to restricted elevator floor." }

    # Add any other necessary attributes or traits here
  end
end