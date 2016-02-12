class Review < ActiveRecord::Base
	belongs_to :booking
	belongs_to :reviewer, class_name: "User"
	belongs_to :reviewee, class_name: "User"

	validates :rating, presence: true, numericality: {
		greater_than_or_equal_to: 1,
		less_than_or_equal_to: 5
	}

	validates :comment, presence: true, length: { in: 42..512 }
end
