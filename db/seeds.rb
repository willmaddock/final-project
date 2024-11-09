require 'faker'
require 'open-uri' # Require open-uri to download images

# Clear existing records only if you want to reset the database
# Uncomment these lines if you want to start fresh each time you seed
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

# Create 50 users with profiles and access logs
50.times do
  # Generate a random password for each user
  password = Faker::Internet.password(min_length: 8)

  user = User.create!(
    username: Faker::Internet.username,
    full_name: Faker::Name.name,
    email: Faker::Internet.email,
    password: password, # Set the password for Devise
    password_confirmation: password, # Ensure password confirmation matches
    role: %w[admin editor viewer shipping_agent logistics_manager].sample, # Assign a random role
    access_level: rand(1..5),
    status: [true, false].sample
  )

  # Create a profile for each user
  profile = Profile.new(
    user: user,
    bio: Faker::Lorem.sentence,
    location: Faker::Address.city
  )

  # Attach an avatar image by downloading it
  begin
    avatar_url = Faker::Avatar.image
    file = URI.open(avatar_url)
    profile.avatar.attach(io: file, filename: 'avatar.png', content_type: 'image/png') # Change content_type as necessary
  rescue OpenURI::HTTPError => e
    puts "Failed to fetch avatar for user #{user.id}: #{e.message}"
    # Attach a default avatar if necessary
    profile.avatar.attach(io: File.open(Rails.root.join('path_to_default_avatar.png')), filename: 'default_avatar.png', content_type: 'image/png')
  end

  profile.save! # This will raise an error if saving fails

  # Optionally, create some access logs for each user
  rand(1..5).times do
    AccessLog.create!(
      user: user,
      access_point_id: rand(1..10), # Now we have 10 access points to reference
      timestamp: Time.now,
      successful: [true, false].sample
    )
  end

  # Create elevated access requests only for shipping agents
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