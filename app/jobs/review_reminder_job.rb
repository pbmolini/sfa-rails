class ReviewReminderJob < ActiveJob::Base
  queue_as :default

  def perform(booking, receiver)
  	# The job email is sent only if the booking exists and it is :accepted.
  	# If it is not, nothing will be done.
  	if booking.present? and booking.accepted?
    	ReviewMailer.remind_review(booking, receiver, I18n.locale.to_s).deliver_now
    end
  end
end
