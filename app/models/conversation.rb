class Conversation < Mailboxer::Conversation
	# self.table_name = self.superclass.table_name
	belongs_to :booking
end
