class BookingMessageMailerPreview < ActionMailer::Preview

	def new_message_email
		BookingMessageMailer.new_message_email(Mailboxer::Message.last, User.first, "it")
	end

	def reply_message_email
		BookingMessageMailer.reply_message_email(Mailboxer::Message.last, User.first, "it")
	end
end