class AddCanceledByToBookings < ActiveRecord::Migration
  def change
    add_reference :bookings, :canceled_by, index: true, foreign_key: true
  end
end
