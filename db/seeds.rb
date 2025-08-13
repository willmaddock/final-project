# db/seeds.rb
require 'faker'
require 'open-uri'

# --- OPTIONAL: Uncomment to reset the database before seeding ---
# User.destroy_all
# Profile.destroy_all
# AccessLog.destroy_all
# AccessPoint.destroy_all
# ElevatedAccessRequest.destroy_all

# Access-related bios and request reasons
access_related_bios = [
  "Experienced in managing secure clearance zones.",
  "Skilled in overseeing restricted access areas.",
  "Specialist in access management and clearance protocols.",
  "Ensures safe and authorized access for all personnel.",
  "Manages access points to maintain security standards.",
  "Trained in securing high-clearance locations.",
  "Coordinates clearance levels for secure facility zones.",
  "Experienced in logistics and clearance procedures.",
  "Supports safe access to restricted areas.",
  "Responsible for managing security clearance protocols.",
  "Expert in logistics clearance and facility security.",
  "Authorized to oversee restricted access points."
]

access_request_reasons = [
  "Request access to secure delivery area",
  "Clearance needed for scheduled delivery",
  "Authorization required for restricted access",
  "Request permission to access loading dock",
  "Urgent access required for high-priority delivery",
  "Temporary clearance request for off-hours access",
  "Access requested to restricted floor for delivery",
  "Immediate access needed to assist with logistics",
  "Clearance request for new restricted area",
  "Scheduled maintenance access clearance request"
]

access_point_descriptions = [
  "Main entrance with restricted access",
  "Loading dock area for authorized personnel",
  "Secure floor with limited access clearance",
  "Warehouse storage area with restricted entry",
  "Administrative office floor for internal use only",
  "Data center floor with high security protocols",
  "Mechanical room with restricted access",
  "Server room access limited to IT staff only",
  "Research lab requiring special clearance",
  "High-security vault for sensitive materials",
  "Access point to executive offices with limited clearance",
  "Private garage for authorized vehicles",
  "Elevator with restricted floor access",
  "Archive room for classified documents",
  "Medical storage area for authorized personnel",
  "Security room monitoring restricted access points",
  "Conference room with limited guest access",
  "Staff-only entrance to secure facility zone",
  "Equipment storage with limited personnel access",
  "Restricted roof access for maintenance only"
]

# Path to default avatar image
default_avatar_path = Rails.root.join("app/assets/images/default_avatar.png")

# Create 10 access points
10.times do
  AccessPoint.create!(
    location: Faker::Address.full_address,
    access_level: rand(1..5),
    description: access_point_descriptions.sample,
    status: [true, false].sample
  )
end

# Create specific admin and logistics manager users
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
    bio: access_related_bios.sample,
    location: Faker::Address.city
  )

  begin
    avatar_url = Faker::Avatar.image
    file = URI.open(avatar_url)
    profile.avatar.attach(io: file, filename: 'avatar.png', content_type: 'image/png')
  rescue => e
    puts "⚠️ Failed to fetch avatar for user #{user.id}: #{e.message}"
    if File.exist?(default_avatar_path)
      profile.avatar.attach(io: File.open(default_avatar_path), filename: 'default_avatar.png', content_type: 'image/png')
    else
      puts "⚠️ Default avatar not found at #{default_avatar_path}"
    end
  end

  profile.save!
end

# Create 50 random users with profiles, access logs, and elevated access requests
50.times do
  password = Faker::Internet.password(min_length: 8)
  user = User.create!(
    username: Faker::Internet.username,
    full_name: Faker::Name.name,
    email: Faker::Internet.email,
    password: password,
    password_confirmation: password,
    role: %w[admin editor viewer shipping_agent logistics_manager].sample,
    access_level: rand(1..5),
    status: [true, false].sample
  )

  profile = Profile.new(
    user: user,
    bio: access_related_bios.sample,
    location: Faker::Address.city
  )

  begin
    avatar_url = Faker::Avatar.image
    file = URI.open(avatar_url)
    profile.avatar.attach(io: file, filename: 'avatar.png', content_type: 'image/png')
  rescue => e
    puts "⚠️ Failed to fetch avatar for user #{user.id}: #{e.message}"
    if File.exist?(default_avatar_path)
      profile.avatar.attach(io: File.open(default_avatar_path), filename: 'default_avatar.png', content_type: 'image/png')
    else
      puts "⚠️ Default avatar not found at #{default_avatar_path}"
    end
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
        reason: access_request_reasons.sample,
        status: %w[pending approved denied].sample
      )
    end
  end
end

puts "✅ Created #{User.count} users, #{Profile.count} profiles, and #{AccessLog.count} access logs."
puts "✅ Created #{AccessPoint.count} access points."
puts "✅ Created #{ElevatedAccessRequest.count} elevated access requests."
