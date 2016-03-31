class ReviewMailer < ActionMailer::Base

	helper :application # gives access to all helpers defined within `application_helper`.
	include Roadie::Rails::Automatic

	layout 'user_mailer'
  default from: "Sea for All <hello@seaforall.com>"

	def new_review(review, receiver, locale)
		I18n.locale = locale.to_sym
		@receiver = receiver
		setup_mailer_from review
		@other_user = @receiver == @reviewer ? @reviewee : @reviewer
		@subject = s_("MailTitle|New review on Sea for All")
		@subject = s_("MailTitle|You posted a review on Sea for All") if @receiver == @reviewer
		@subject = s_("MailTitle|You received a review on Sea for All") if @receiver == @reviewee
		mail to: @receiver.email, subject: @subject
	end

	def remind_review(booking, receiver, locale)
		I18n.locale = locale.to_sym
		@receiver = receiver
		@booking = booking
		@guest = booking.user
		@boat = booking.boat
		@host = booking.boat.user
		@other_user = @receiver == @host ? @guest : @host
		@subject = s_("MailTitle|Review your experience")
		@subject = (s_("MailTitle|Leave a review for %{boat_name}") %{boat_name: @boat.name}) if @receiver == @guest
		@subject = (s_("MailTitle|Leave a review to %{guest_name}") %{guest_name: @guest.name}) if @receiver == @host
		mail to: @receiver.email, subject: @subject
	end

	private

	def setup_mailer_from(review)
		@review = review
		@booking = review.booking
		@guest = review.booking.user
		@boat = review.booking.boat
		@host = review.booking.boat.user
		@reviewer = review.reviewer
		@reviewee = review.reviewee
	end
	
	
end