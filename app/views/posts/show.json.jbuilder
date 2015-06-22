json.set!('image_url', @post.image.url)
json.extract! @post, :id, :title, :description, :created_at, :updated_at
