json.array!(@boat_features) do |boat_feature|
  json.extract! boat_feature, :id, :name, :boat_category_id
  json.url boat_feature_url(boat_feature, format: :json)
end
