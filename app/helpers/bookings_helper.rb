module BookingsHelper
	# A booking starts at 00:00 of the first day and 
	# terminates at 23:59 of the last day, so dividing 
	# by 24hours * 60minutes * 60seconds would lose the
	# final day, that is why we add 1 at the end.
	def booking_duration_in_days(duration_in_seconds)
		(duration_in_seconds.to_i / (24 * 60 * 60)) + 1
	end

	def booking_state_icon(booking)
		if booking.pending?
      "clock-o"
    elsif booking.accepted?
      "check-circle-o"
    elsif booking.rejected?
      "minus-circle"
    elsif booking.canceled?
      "times-circle-o"
    else
      "question-circle"
    end
	end

	# Returns the tooltip text for each state
	# It's not DRY but it's easy for managing translations
	def booking_state_tooltip_text(booking)
		if booking.pending?
      s_("BookingStateTooltip|Pending Booking")
    elsif booking.accepted?
      s_("BookingStateTooltip|Accepted Booking")
    elsif booking.rejected?
      s_("BookingStateTooltip|Rejected Booking")
    elsif booking.canceled?
      s_("BookingStateTooltip|Canceled Booking")
    else
      s_("BookingStateTooltip|Undefined Booking")
    end
	end

  # Same as above, returns the state name given the state symbol
  def booking_state_name(state)
    case state
    when :pending
      s_("BookingStateName|Pending")
    when :accepted
      s_("BookingStateName|Accepted")
    when :rejected
      s_("BookingStateName|Rejected")
    when :canceled
      s_("BookingStateName|Canceled")
    else
      s_("BookingStateName|Undefined")
    end
  end

  def bookings_counter_badge count, role
    if count > 0
      content_tag :span, count, class: "badge booking-badge badge-#{role}"
    end
  end

  def other_user_for(booking)
    current_user == booking.user ? booking.boat.user : booking.user
  end

end