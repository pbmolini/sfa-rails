class MCUserGroupUpdate < Struct.new(:mc_member_id, :boat_started, :boat_complete, :boat_none)

	def perform

		list_id = ENV['MC_REGISTERED_USERS_LIST_ID']
		boat_complete_id = ENV['MC_BOAT_COMPLETE_GROUP_ID']
		boat_started_id = ENV['MC_BOAT_STARTED_GROUP_ID']
		boat_none_id = ENV['MC_BOAT_NONE_GROUP_ID']

		gibbon = Gibbon::Request.new
		
		# put user's email in the corresponding group
		gibbon.lists(list_id).members(mc_member_id).update(
			body: {
				interests: {
					boat_started_id => boat_started, 
					boat_complete_id => boat_complete, 
					boat_none_id => boat_none
					}
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