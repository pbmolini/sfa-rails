class BookingStateMessage < Mailboxer::Message

  def initialize(sender, conversation, booking, body = nil)
    super({
      sender: sender,
      conversation: conversation,
      recipients: [booking.user],
      subject: conversation.subject,
      body: body || state_change_message(booking),
      booking_state_change: booking.aasm_state
    })
  end

  def is_booking_state_change?
    not booking_state_change.nil?
  end

  private

  def state_change_message booking
    case booking.aasm_state.to_sym
    when :accepted
      _("I accept your booking. Enjoy my boat!")
    when :rejected
      _("Sorry, I reject your booking.")
    when :canceled
      _("Sorry, I must cancel this booking.")
    end
  end
end
