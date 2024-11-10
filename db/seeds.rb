require 'faker'
require 'open-uri'

# Clear existing records if you want to reset the database (uncomment if needed)
# User.destroy_all
# Profile.destroy_all
# AccessLog.destroy_all
# AccessPoint.destroy_all
# ElevatedAccessRequest.destroy_all

# Create 10 access points
10.times do
  AccessPoint.create!(
    location: Faker::Address.full_address,
    access_level: rand(1..5),
    description: Faker::Lorem.sentence,
    status: [true, false].sample
  )
end

# Create specific admin and logistics manager users for presentation
admin_user = User.create!(
  username: 'admin',
  full_name: 'Admin User',
  email: 'admin@example.com',
  password: 'password',
  password_confirmation: 'password',
  role: 'admin',
  access_level: 0,
  status: true
)

logistics_manager_user = User.create!(
  username: 'logistics_manager',
  full_name: 'Logistics Manager',
  email: 'logistics_manager@example.com',
  password: 'password',
  password_confirmation: 'password',
  role: 'logistics_manager',
  access_level: 4,
  status: true
)

# Attach profiles for admin and logistics manager
[admin_user, logistics_manager_user].each do |user|
  profile = Profile.new(
    user: user,
    bio: Faker::Lorem.sentence,
    location: Faker::Address.city
  )

  # Attach an avatar image for each
  begin
    avatar_url = Faker::Avatar.image
    file = URI.open(avatar_url)
    profile.avatar.attach(io: file, filename: 'avatar.png', content_type: 'image/png')
  rescue OpenURI::HTTPError => e
    puts "Failed to fetch avatar for user #{user.id}: #{e.message}"
    profile.avatar.attach(io: File.open(Rails.root.join('path_to_default_avatar.png')), filename: 'default_avatar.png', content_type: 'image/png')
  end

  profile.save!
end

# Create additional random users with profiles, access logs, and elevated access requests
50.times do
  password = Faker::Internet.password(min_length: 8)
  user = User.create!(
    username: Faker::Internet.username,
    full_name: Faker::Name.name,
    email: Faker::Internet.email,
    password: password,
    password_confirmation: password,
    role: %w[editor viewer shipping_agent].sample,
    access_level: rand(1..5),
    status: [true, false].sample
  )

  profile = Profile.new(
    user: user,
    bio: Faker::Lorem.sentence,
    location: Faker::Address.city
  )

  begin
    avatar_url = Faker::Avatar.image
    file = URI.open(avatar_url)
    profile.avatar.attach(io: file, filename: 'avatar.png', content_type: 'image/png')
  rescue OpenURI::HTTPError => e
    puts "Failed to fetch avatar for user #{user.id}: #{e.message}"
    profile.avatar.attach(io: File.open(Rails.root.join('path_to_default_avatar.png')), filename: 'default_avatar.png', content_type: 'image/png')
  end

  profile.save!

  rand(1..5).times do
    AccessLog.create!(
      user: user,
      access_point_id: rand(1..10),
      timestamp: Time.now,
      successful: [true, false].sample
    )
  end

  if user.role == 'shipping_agent'
    rand(1..3).times do
      ElevatedAccessRequest.create!(
        user: user,
        access_point_id: rand(1..10),
        reason: Faker::Lorem.sentence,
        status: %w[pending approved denied].sample
      )
    end
  end
end

puts "Created #{User.count} users, #{Profile.count} profiles, and #{AccessLog.count} access logs."
puts "Created #{AccessPoint.count} access points."
puts "Created #{ElevatedAccessRequest.count} elevated access requests."