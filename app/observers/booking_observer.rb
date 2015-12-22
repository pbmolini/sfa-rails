class BookingObserver < ActiveRecord::Observer
	
	def after_create(booking)
		# Create the message and start the conversation
		sender = booking.user
		recipient = booking.boat.user
		conversation = sender.send_message(recipient, body_for(booking), subject_for(booking)).conversation
		conversation.booking_id = booking.id
		conversation.save # TODO What if this goes wrong?
	end

	private

	def body_for(booking)
		if booking.duration_in_days > 1
			_("Hi %{first_name}, I would like to book %{boat_name} from %{first_day} to %{last_day}" %{first_name: booking.boat.user.first_name, boat_name: booking.boat.name, first_day: booking.first_day_in_locale, last_day: booking.last_day_in_locale})
		else
			_("Hi %{first_name}, I would like to book %{boat_name} on the %{first_day}" %{first_name: booking.boat.user.first_name, boat_name: booking.boat.name, first_day: booking.first_day_in_locale})
		end
	end

	def subject_for(booking)
		if booking.duration_in_days > 1
			_("%{duration} days from %{first_day} to %{last_day}" %{duration: booking.duration_in_days, first_day: booking.first_day_in_locale, last_day: booking.last_day_in_locale})
		else
			_("One day on %{first_day}" %{first_day: booking.first_day_in_locale})
		end
	end
	
end