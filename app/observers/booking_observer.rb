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
		start_time = I18n.l(booking.start_time.in_time_zone, format: :short)
		end_time = I18n.l(booking.end_time.in_time_zone, format: :short)
		_("Hi #{booking.boat.user.first_name}, I would like to book #{booking.boat.name} from #{start_time} to #{end_time}")
	end

	def subject_for(booking)
		start_time = I18n.l(booking.start_time.in_time_zone, format: :short)
		end_time = I18n.l(booking.end_time.in_time_zone, format: :short)
		_("From #{start_time} to #{end_time}")
	end
	
end