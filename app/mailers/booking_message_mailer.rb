class BookingMessageMailer < Mailboxer::BaseMailer

  helper :application # gives access to all helpers defined within `application_helper`.
  include Roadie::Rails::Automatic
  
  layout 'user_mailer'
  default from: "SeaForAll <hello@seaforall.com>"

  # Sends and email for indicating a new message or a reply to a receiver.
  # It calls new_message_email if notifing a new message and reply_message_email
  # when indicating a reply to an already created conversation.
  def send_email(message, receiver, locale)
    if message.conversation.messages.size > 1
      reply_message_email(message, receiver, locale)
    else
      new_message_email(message, receiver, locale)
    end
  end

  # Sends an email for indicating a new message for the receiver, i.e. a new Booking
  def new_message_email(message, receiver, locale)
    I18n.locale = locale.to_sym
    @message  = message
    @sender = message.sender
    @receiver = receiver
    @booking = Booking.find(message.conversation.booking_id) # TODO: improve using .booking
    @boat = @booking.boat
    @guest = @booking.user
    @host = @boat.user
    set_subject(message)
    mail to: receiver.send(Mailboxer.email_method, message),
         subject: (_("New booking for %{boat_name} on Sea for All") %{boat_name: @boat.name}),
         template_name: 'new_message_email'
  end

  # Sends and email for indicating a reply in an already created conversation, i.e. Booking
  def reply_message_email(message, receiver, locale)
    I18n.locale = locale.to_sym
    @message  = message
    @sender = message.sender
    @receiver = receiver
    @booking = Booking.find(message.conversation.booking_id) # TODO: improve using .booking
    @boat = @booking.boat
    @guest = @booking.user
    @host = @boat.user
    set_subject(message)
    mail to: receiver.send(Mailboxer.email_method, message),
         subject: (s_("NewReplyMailSubject|New message from %{sender_name} on Sea for All") %{sender_name: @sender.name}),
         template_name: 'reply_message_email'
  end
end