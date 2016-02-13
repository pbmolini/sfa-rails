class BookingStateMailer < ActionMailer::Base
	helper :application # gives access to all helpers defined within `application_helper`.
	include Roadie::Rails::Automatic

	layout 'user_mailer'
  default from: "SeaForAll <hello@seaforall.com>"

  def send_email(receiver, booking, state, locale)
  	case state
  	when 'accepted'
  		booking_accepted receiver, booking, locale

  	when 'rejected'
  		booking_rejected receiver, booking, locale
  		
  	when 'canceled'
  		booking_canceled receiver, booking, locale
  		
  	end
  end
	
	def booking_accepted(receiver, booking, locale)
		I18n.locale = locale.to_sym
		@receiver = receiver
		@booking = booking
		@boat = booking.boat
		@guest = @booking.user
		@host = @boat.user
		subj = ""
		if @receiver == @guest
			# Guest
			subj = s_("MailTitle|%{host_name} has accepted your booking on Sea for All") %{host_name: @host.name}
		else
			# Host
			subj = s_("MailTitle|You have accepted a booking on Sea for All")
		end
		mail to: @receiver.email, subject: subj, template_name: 'booking_accepted'
	end

	def booking_rejected(receiver, booking, locale)
		I18n.locale = locale.to_sym
		@receiver = receiver
		@booking = booking
		@boat = booking.boat
		@guest = @booking.user
		@host = @boat.user
		subj = ""
		if @receiver == @guest
			# Guest
			subj = s_("MailTitle|%{host_name} has rejected your booking on Sea for All") %{host_name: @host.name}
		else
			# Host
			subj = s_("MailTitle|You have rejected a booking on Sea for All")
		end
		mail to: @receiver.email, subject: subj, template_name: 'booking_rejected'
	end

	def booking_canceled(receiver, booking, locale)
		I18n.locale = locale.to_sym
		@canceler = booking.canceled_by_id.present? ? User.find(booking.canceled_by_id) : nil
		@receiver = receiver
		@booking = booking
		@boat = booking.boat
		@guest = @booking.user
		@host = @boat.user
		subj = ""
		if @receiver == @guest
			# Guest
			subj = s_("MailTitle|One of your bookings has been canceled on Sea for All")
		else
			# Host
			subj = s_("MailTitle|One of your bookings has been canceled on Sea for All")
		end
		mail to: @receiver.email, subject: subj, template_name: 'booking_canceled'
	end
	
end