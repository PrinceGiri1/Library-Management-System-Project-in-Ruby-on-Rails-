json.extract! admin, :id, :email, :name, :password, :created_at, :updated_at
json.url admin_url(admin, format: :json)
