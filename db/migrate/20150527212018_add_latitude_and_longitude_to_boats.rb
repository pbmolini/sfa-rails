class AddLatitudeAndLongitudeToBoats < ActiveRecord::Migration
  def change
    add_column :boats, :latitude, :float
    add_column :boats, :longitude, :float

    Boat.find_each do |b|
      coords = b.geocode
      if coords
        b.update_columns latitude: coords.first, longitude: coords.last
      end
    end
  end
end
