json.extract! access_log, :id, :user_id, :access_point_id, :timestamp, :successful, :created_at, :updated_at
json.url access_log_url(access_log, format: :json)
