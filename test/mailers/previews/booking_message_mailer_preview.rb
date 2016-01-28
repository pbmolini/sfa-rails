class BookingMessageMailerPreview < ActionMailer::Preview

	def new_message_email_to_host
		message = Mailboxer::Message.last
		booking = Booking.find(message.conversation.booking_id)
		BookingMessageMailer.new_message_email(message, booking.boat.user, "it")
	end

	def new_message_email_to_guest
		message = Mailboxer::Message.last
		booking = Booking.find(message.conversation.booking_id)
		BookingMessageMailer.new_message_email(message, booking.user, "it")
	end

	def reply_message_email_to_host
		message = Mailboxer::Message.last
		booking = Booking.find(message.conversation.booking_id)
		BookingMessageMailer.reply_message_email(message, booking.boat.user, "it")
	end

	def reply_message_email_to_guest
		message = Mailboxer::Message.last
		booking = Booking.find(message.conversation.booking_id)
		BookingMessageMailer.reply_message_email(message, booking.user, "it")
	end
end