json.array!(@bookings) do |booking|
  json.extract! booking, :id, :start_time, :end_time, :people_on_board, :boat_id
  json.url booking_url(booking, format: :json)
end
