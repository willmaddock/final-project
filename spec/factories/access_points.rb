# spec/factories/access_points.rb

FactoryBot.define do
  factory :access_point do
    location { "MyString" }
    access_level { 1 }
    description { "MyText" }
    status { false }

    # Optionally, you can add traits if you want specific variations.
    trait :active do
      status { true }
    end

    trait :with_high_access_level do
      access_level { 3 }
    end
  end
end