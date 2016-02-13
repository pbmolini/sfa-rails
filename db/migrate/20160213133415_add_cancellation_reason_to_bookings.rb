class AddCancellationReasonToBookings < ActiveRecord::Migration
  def change
    add_column :bookings, :cancellation_reason, :text
  end
end
