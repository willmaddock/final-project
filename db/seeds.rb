require 'faker'
require 'open-uri'

# Define lists for access-related bios and request reasons
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

# Clear existing records (optional, use with caution in production)
# User.delete_all
# Profile.delete_all
# AccessLog.delete_all
# AccessPoint.delete_all
# ElevatedAccessRequest.delete_all
# ActiveStorage::Attachment.delete_all
# ActiveStorage::Blob.delete_all

# Create 10 access points
10.times do |i|
  AccessPoint.find_or_create_by!(location: Faker::Address.full_address) do |ap|
    ap.access_level = rand(1..5)
    ap.description = access_point_descriptions[i % access_point_descriptions.length]
    ap.status = [true, false].sample
  end
end

# Create specific admin and logistics manager users
admin_user = User.find_or_create_by!(username: 'admin', email: 'admin@example.com') do |user|
  user.full_name = 'Admin User'
  user.password = 'password'
  user.password_confirmation = 'password'
  user.role = 'admin'
  user.access_level = 0
  user.status = true
end

logistics_manager_user = User.find_or_create_by!(username: 'logistics_manager', email: 'logistics_manager@example.com') do |user|
  user.full_name = 'Logistics Manager'
  user.password = 'password'
  user.password_confirmation = 'password'
  user.role = 'logistics_manager'
  user.access_level = 4
  user.status = true
end

# Attach profiles for admin and logistics manager
[admin_user, logistics_manager_user].each do |user|
  profile = Profile.find_or_create_by!(user: user) do |p|
    p.bio = access_related_bios.sample
    p.location = Faker::Address.city
  end

  # Attach an avatar image if not already attached
  unless profile.avatar.attached?
    begin
      avatar_url = Faker::Avatar.image
      file = URI.open(avatar_url)
      profile.avatar.attach(io: file, filename: 'avatar.png', content_type: 'image/png')
    rescue OpenURI::HTTPError, Errno::ENOENT, StandardError => e
      puts "Failed to fetch avatar for user #{user.id}: #{e.message}"
      begin
        default_avatar_path = Rails.root.join('app/assets/images/default_profile_picture.png')
        profile.avatar.attach(io: File.open(default_avatar_path), filename: 'default_profile_picture.png', content_type: 'image/png')
      rescue Errno::ENOENT => e
        puts "Default avatar not found at #{default_avatar_path}: #{e.message}"
      end
    end
  end
end

# Create additional random users with profiles, access logs, and elevated access requests
15.times do
  # Generate unique username and email
  loop do
    @username = Faker::Internet.username
    @email = Faker::Internet.email
    break unless User.exists?(username: @username) || User.exists?(email: @email)
  end

  user = User.find_or_create_by!(username: @username, email: @email) do |u|
    password = Faker::Internet.password(min_length: 8)
    u.full_name = Faker::Name.name
    u.password = password
    u.password_confirmation = password
    u.role = %w[admin editor viewer shipping_agent logistics_manager].sample
    u.access_level = rand(1..5)
    u.status = [true, false].sample
  end

  profile = Profile.find_or_create_by!(user: user) do |p|
    p.bio = access_related_bios.sample
    p.location = Faker::Address.city
  end

  unless profile.avatar.attached?
    begin
      avatar_url = Faker::Avatar.image
      file = URI.open(avatar_url)
      profile.avatar.attach(io: file, filename: 'avatar.png', content_type: 'image/png')
    rescue OpenURI::HTTPError, Errno::ENOENT, StandardError => e
      puts "Failed to fetch avatar for user #{user.id}: #{e.message}"
      begin
        default_avatar_path = Rails.root.join('app/assets/images/default_profile_picture.png')
        profile.avatar.attach(io: File.open(default_avatar_path), filename: 'default_profile_picture.png', content_type: 'image/png')
      rescue Errno::ENOENT => e
        puts "Default avatar not found at #{default_avatar_path}: #{e.message}"
      end
    end
  end

  rand(1..5).times do
    AccessLog.find_or_create_by!(user: user, access_point_id: rand(1..10), timestamp: Time.now) do |log|
      log.successful = [true, false].sample
    end
  end

  if user.role == 'shipping_agent'
    rand(1..3).times do
      ElevatedAccessRequest.find_or_create_by!(user: user, access_point_id: rand(1..10)) do |request|
        request.reason = access_request_reasons.sample
        request.status = %w[pending approved denied].sample
      end
    end
  end
end

puts "Created #{User.count} users, #{Profile.count} profiles, and #{AccessLog.count} access logs."
puts "Created #{AccessPoint.count} access points."
puts "Created #{ElevatedAccessRequest.count} elevated access requests."