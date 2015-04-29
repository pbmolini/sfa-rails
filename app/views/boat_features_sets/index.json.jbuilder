json.array!(@boat_features_sets) do |boat_features_set|
  json.extract! boat_features_set, :id, :boat_id, :vhf, :depth_finder
  json.url boat_features_set_url(boat_features_set, format: :json)
end
