json.extract! post, :id, :titel, :description, :keyword, :created_at, :updated_at
json.url post_url(post, format: :json)
