class AddFeaturedToBoats < ActiveRecord::Migration
  def change
    add_column :boats, :featured, :boolean, default: false
  end
end
