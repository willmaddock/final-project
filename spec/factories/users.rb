FactoryBot.define do
  factory :user do
    # Default user attributes
    username { "john_doe" }
    full_name { "John Doe" }
    email { "john.doe@example.com" }
    role { "admin" }
    access_level { 1 }
    last_login { "2024-11-01 00:46:48" }
    status { true }

    # Devise password handling (Devise handles encryption)
    password { "password" }
    password_confirmation { "password" }

    # Trait for admin role
    trait :admin do
      username { "john_doe" }
      full_name { "John Doe" }
      email { "john.doe@example.com" }
      role { 'admin' }
      access_level { 1 }
    end

    # Trait for logistics manager role
    trait :logistics_manager do
      username { "jane_smith" }
      full_name { "Jane Smith" }
      email { "jane.smith@example.com" }
      role { 'logistics_manager' }
      access_level { 2 }
    end

    # Trait for shipping agent role
    trait :shipping_agent do
      username { "shipping_agent_user" }
      full_name { "Agent Smith" }
      email { "agent.smith@example.com" }
      role { 'shipping_agent' }
      access_level { 3 }
    end
  end
end