class BookingMessageMailer < Mailboxer::BaseMailer

  helper :application # gives access to all helpers defined within `application_helper`.
  include Roadie::Rails::Automatic
  
  layout 'user_mailer'
  default from: "SeaForAll <hello@seaforall.com>"
  
  #Sends and email for indicating a new message or a reply to a receiver.
  #It calls new_message_email if notifing a new message and reply_message_email
  #when indicating a reply to an already created conversation.
  def send_email(message, receiver)
    if message.conversation.messages.size > 1
      reply_message_email(message, receiver)
    else
      new_message_email(message, receiver)
    end
  end

  # Sends an email for indicating a new message for the receiver, i.e. a new Booking
  def new_message_email(message, receiver)
    @message  = message
    @receiver = receiver
    @booking = Booking.find(message.conversation.booking_id) # TODO: improve using .booking
    @boat = @booking.boat
    set_subject(message)
    mail to: receiver.send(Mailboxer.email_method, message),
         subject: (_("You have a new booking for %{boat_name}") %{boat_name: @boat.name}),
         template_name: 'new_message_email'
  end

  # Sends and email for indicating a reply in an already created conversation, i.e. Booking
  def reply_message_email(message, receiver)
    @message  = message
    @receiver = receiver
    @booking = Booking.find(message.conversation.booking_id) # TODO: improve using .booking
    @boat = @booking.boat
    set_subject(message)
    mail to: receiver.send(Mailboxer.email_method, message),
         subject: (_("%{sender_name} just replied about booking %{boat_name}") %{sender_name: @message.sender.name, boat_name: @boat.name}),
         template_name: 'reply_message_email'
  end
end