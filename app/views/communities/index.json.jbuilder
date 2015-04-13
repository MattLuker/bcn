json.array!(@communities) do |community|
  json.extract! community, :id, :name, :description, :home_page, :color
  json.url community_url(community, format: :json)
end
