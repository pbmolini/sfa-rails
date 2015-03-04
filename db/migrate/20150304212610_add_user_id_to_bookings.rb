class AddUserIdToBookings < ActiveRecord::Migration
  def change
    add_belongs_to :bookings, :user
  end
end
