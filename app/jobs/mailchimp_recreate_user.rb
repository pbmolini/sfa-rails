class MailchimpRecreateUser < Struct.new(:user_id)

	def perform
		# get the user
		user = User.find user_id

		list_id = ENV['MC_REGISTERED_USERS_LIST_ID']
		boat_complete_id = ENV['MC_BOAT_COMPLETE_GROUP_ID']
		boat_started_id = ENV['MC_BOAT_STARTED_GROUP_ID']
		boat_none_id = ENV['MC_BOAT_NONE_GROUP_ID']

		gibbon = Gibbon::Request.new

		# Remove the user's email
		gibbon.lists(list_id).members(user.mc_member_id).update(
			body: {
				status: "unsubscribed"
				})

		# Re-add user's email to MC list
		member = gibbon.lists(list_id).members.create(
			body: {
				email_address: user.email,
				status: "subscribed",
				merge_fields: {FNAME: user.first_name, LNAME: user.last_name}
				}).body

		# Put user's email in correct group
		gibbon.lists(list_id).members(member["id"]).update(
			body: {
				interests: {
					boat_started_id => user.boats.incomplete.any?,
					boat_complete_id => user.boats.complete.any?,
					boat_none_id => user.boats.empty?
					}
				})

		# save the member["id"] (don't `save` to skip validations)
		user.update_attribute(:mc_member_id, member["id"])
	end

	# Uncomment when debugging and check .env
	# def error(job, exception)
	# 	Delayed::Worker.logger.error exception
	# end

	# def reschedule_at(current_time, attempts)
	# 	current_time + 30.seconds
	# end

end
