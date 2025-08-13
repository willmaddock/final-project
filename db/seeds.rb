# db/seeds.rb
require "faker"

# ✅ Core demo users (admin + logistics_manager)
admin = User.find_or_initialize_by(email: "admin@example.com")
admin.update!(
  username: "admin",
  full_name: "Admin User",
  password: "password",
  password_confirmation: "password",
  role: "admin",
  access_level: 0,
  status: true
)

logistics = User.find_or_initialize_by(email: "logistics_manager@example.com")
logistics.update!(
  username: "logistics_manager",
  full_name: "Logistics Manager",
  password: "password",
  password_confirmation: "password",
  role: "logistics_manager",
  access_level: 4,
  status: true
)

# ✅ Access Points (create if fewer than 10 exist)
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

if AccessPoint.count < 10
  10.times do
    AccessPoint.create!(
      location: Faker::Address.full_address,
      access_level: rand(1..5),
      description: access_point_descriptions.sample,
      status: [true, false].sample
    )
  end
end

# ✅ Attach default avatar (no network calls for stability)
default_avatar_path = Rails.root.join("app/assets/images/default_avatar.png")

[admin, logistics].each do |user|
  profile = user.profile || user.build_profile(
    bio: "Ensures safe and authorized access for all personnel.",
    location: Faker::Address.city
  )

  unless profile.avatar.attached?
    if File.exist?(default_avatar_path)
      profile.avatar.attach(
        io: File.open(default_avatar_path),
        filename: "default_avatar.png",
        content_type: "image/png"
      )
    end
  end

  profile.save!
end

# ✅ Bulk random users (top‑up to 52 total)
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

ap_ids = AccessPoint.pluck(:id)

if User.count < 52
  (52 - User.count).times do
    pwd = Faker::Internet.password(min_length: 8)
    user = User.create!(
      username: Faker::Internet.unique.username,
      full_name: Faker::Name.name,
      email: Faker::Internet.unique.email,
      password: pwd,
      password_confirmation: pwd,
      role: %w[admin editor viewer shipping_agent logistics_manager].sample,
      access_level: rand(1..5),
      status: [true, false].sample
    )

    profile = user.build_profile(
      bio: access_related_bios.sample,
      location: Faker::Address.city
    )

    if File.exist?(default_avatar_path)
      profile.avatar.attach(
        io: File.open(default_avatar_path),
        filename: "default_avatar.png",
        content_type: "image/png"
      )
    end

    profile.save!

    rand(1..5).times do
      AccessLog.create!(
        user: user,
        access_point_id: ap_ids.sample,
        timestamp: Time.current,
        successful: [true, false].sample
      )
    end

    if user.role == "shipping_agent"
      rand(1..3).times do
        ElevatedAccessRequest.create!(
          user: user,
          access_point_id: ap_ids.sample,
          reason: access_request_reasons.sample,
          status: %w[pending approved denied].sample
        )
      end
    end
  end
end

puts "Users: #{User.count} | Profiles: #{Profile.count} | AccessLogs: #{AccessLog.count} | AccessPoints: #{AccessPoint.count} | ElevatedRequests: #{ElevatedAccessRequest.count}"
