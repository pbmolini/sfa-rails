json.array!(@boats) do |boat|
  json.extract! boat, :id, :name, :manufacturer, :daily_price, :year, :model, :length, :guest_capacity, :boat_category_id
  json.url boat_url(boat, format: :json)
end
