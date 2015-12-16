class BookingStateMailerPreview < ActionMailer::Preview

	# Accepted
	def booking_accepted_to_guest
		BookingStateMailer.booking_accepted(Booking.last.user, Booking.last, "it")
	end

	def booking_accepted_to_host
		BookingStateMailer.booking_accepted(Booking.last.boat.user, Booking.last, "it")
	end

	# Rejected
	def booking_rejected_to_guest
		BookingStateMailer.booking_rejected(Booking.last.user, Booking.last, "it")
	end

	def booking_rejected_to_host
		BookingStateMailer.booking_rejected(Booking.last.boat.user, Booking.last, "it")
	end

	# Canceled
	def booking_canceled_to_guest
		BookingStateMailer.booking_canceled(Booking.last.user, Booking.last, "it")
	end

	def booking_canceled_to_host
		BookingStateMailer.booking_canceled(Booking.last.boat.user, Booking.last, "it")
	end
end