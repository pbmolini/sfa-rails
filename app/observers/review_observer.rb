class ReviewObserver < ActiveRecord::Observer
	def after_create(review)
		# Mail to the reviewer
		ReviewMailer.new_review(review, review.reviewer, I18n.locale.to_s).deliver_later

		# Mail to the reviewee
		ReviewMailer.new_review(review, review.reviewee, I18n.locale.to_s).deliver_later
	end
	
	
end