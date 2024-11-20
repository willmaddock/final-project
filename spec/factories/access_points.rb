# spec/factories/access_points.rb

FactoryBot.define do
  factory :access_point do
    location { "MyString" } # Default location; customize for your tests
    access_level { 1 } # Default access level
    description { "MyText" } # Default description
    status { false } # Default status is inactive

    # Traits for creating variations of access points
    trait :active do
      status { true } # Sets the access point status to active
    end

    trait :with_high_access_level do
      access_level { 3 } # Sets a higher access level for restricted areas
    end

    # Example of combining traits to create an active access point with high access level
    factory :active_high_access_point, traits: [:active, :with_high_access_level]
  end
end