class BoatObserver < ActiveRecord::Observer
	
	def after_commit boat
		# Add the user to the Mailchimp list and put it un the correct, only in production and staging
    # unless Rails.env == "development"
	    Delayed::Job.enqueue MCUserGroupUpdate.new(
	    	boat.user.mc_member_id,
	    	(not boat.complete?), # boat_started
	    	boat.complete?, # boat_complete
	    	false # boat_none
	    	)
	  # end
	end
	
end