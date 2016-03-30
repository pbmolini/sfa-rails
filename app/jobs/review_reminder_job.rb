class ReviewReminderJob < ActiveJob::Base
  queue_as :default

  def perform(booking, receiver)
    ReviewMailer.remind_review(booking, receiver, I18n.locale.to_s).deliver_now
  end
end
