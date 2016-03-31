class ReviewMailerPreview < ActionMailer::Preview

	def new_review_to_reviewer
		ReviewMailer.new_review(Review.last, Review.last.reviewer, "it")
	end

	def new_review_to_reviewee
		ReviewMailer.new_review(Review.last, Review.last.reviewee, "it")
	end

	def remind_review_to_host
		ReviewMailer.remind_review(Booking.last, Booking.last.boat.user, "it")
	end

	def remind_review_to_guest
		ReviewMailer.remind_review(Booking.last, Booking.last.user, "it")
	end

end