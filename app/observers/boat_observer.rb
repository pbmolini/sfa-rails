class BoatObserver < ActiveRecord::Observer
	
	def after_commit boat
		# Add the user to the correct Mailchimp group
		# Used only in production and staging, comments the `unless .. end` for debugging
    unless Rails.env == "development"
	    Delayed::Job.enqueue MCUserGroupUpdate.new(
	    	boat.user.mc_member_id,
	    	(not boat.complete?), # boat_started
	    	boat.complete?, # boat_complete
	    	false # boat_none
	    	)
	  end
	end
	
end