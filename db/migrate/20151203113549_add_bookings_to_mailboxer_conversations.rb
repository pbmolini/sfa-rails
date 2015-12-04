class AddBookingsToMailboxerConversations < ActiveRecord::Migration
  def change
    add_reference :mailboxer_conversations, :booking, index: true, foreign_key: true
  end
end
