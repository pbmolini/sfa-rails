class AddStateChangeInfoToMailboxerNotifications < ActiveRecord::Migration
  def change

    add_column :mailboxer_notifications, :booking_state_change, :string

  end
end
