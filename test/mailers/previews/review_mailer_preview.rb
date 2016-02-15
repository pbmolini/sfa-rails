class ReviewMailerPreview < ActionMailer::Preview
	def new_review_to_reviewer
		ReviewMailer.new_review(Review.last, Review.last.reviewer, "it")
	end

	def new_review_to_reviewee
		ReviewMailer.new_review(Review.last, Review.last.reviewee, "it")
	end
end