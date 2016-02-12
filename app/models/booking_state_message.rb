class BookingStateMessage < Mailboxer::Message
  def is_booking_state_change?
    not booking_state_change.nil?
  end
end
