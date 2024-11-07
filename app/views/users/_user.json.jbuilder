json.extract! user, :id, :username, :password_hash, :full_name, :email, :role, :access_level, :last_login, :status, :created_at, :updated_at
json.url user_url(user, format: :json)
