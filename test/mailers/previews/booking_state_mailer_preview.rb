class BookingStateMailerPreview < ActionMailer::Preview

	def booking_accepted
		BookingStateMailer.booking_accepted(User.first, Booking.last, "it")
	end

	def booking_rejected
		BookingStateMailer.booking_rejected(User.first, Booking.last, "it")
	end

	def booking_canceled
		BookingStateMailer.booking_canceled(User.first, Booking.last, "it")
	end
end