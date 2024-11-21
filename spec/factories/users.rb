FactoryBot.define do
  factory :user do
    username { Faker::Internet.unique.username(specifier: 5..10) }
    full_name { Faker::Name.name }
    email { Faker::Internet.unique.email }
    role { "admin" }
    access_level { 1 }
    last_login { Time.current }
    status { true }

    password { "password" }
    password_confirmation { "password" }

    # Traits for specific roles
    trait :admin do
      role { "admin" }
      access_level { 1 }
    end

    trait :logistics_manager do
      role { "logistics_manager" }
      access_level { 2 }
    end

    trait :shipping_agent do
      role { "shipping_agent" }
      access_level { 3 }
    end
  end
end