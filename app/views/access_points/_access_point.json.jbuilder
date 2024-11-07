json.extract! access_point, :id, :location, :access_level, :description, :status, :created_at, :updated_at
json.url access_point_url(access_point, format: :json)
