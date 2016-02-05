class MailchimpDeletedUser < Struct.new(:mc_member_id)
	def perform
		list_id = ENV['MC_REGISTERED_USERS_LIST_ID']
		gibbon = Gibbon::Request.new
		gibbon.lists(list_id).members(mc_member_id).update(
			body: { 
				status: "unsubscribed" 
				})
	end
	
	# Uncomment when debugging and check .env
	# def error(job, exception)		
	# 	Delayed::Worker.logger.error exception
	# end

	# def reschedule_at(current_time, attempts)
	# 	current_time + 30.seconds
	# end
	
end