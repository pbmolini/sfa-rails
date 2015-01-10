json.array!(@boat_categories) do |boat_category|
  json.extract! boat_category, :id, :name
  json.url boat_category_url(boat_category, format: :json)
end
