module BookingsHelper
	# A booking starts at 00:00 of the first day and 
	# terminates at 23:59 of the last day, so dividing 
	# by 24hours * 60minutes * 60seconds would lose the
	# final day, that is why we add 1 at the end.
	def booking_duration_in_days(duration_in_seconds)
		(duration_in_seconds.to_i / (24 * 60 * 60)) + 1
	end
end
