class MailchimpRegisteredUser < Struct.new(:user_id, :first_name, :last_name, :email)

	def perform
		# get the user
		user = User.find user_id

		list_id = ENV['MC_REGISTERED_USERS_LIST_ID']
		boat_complete_id = ENV['MC_BOAT_COMPLETE_GROUP_ID']
		boat_started_id = ENV['MC_BOAT_STARTED_GROUP_ID']
		boat_none_id = ENV['MC_BOAT_NONE_GROUP_ID']

		gibbon = Gibbon::Request.new

		# add user's email to MC list
		member = gibbon.lists(list_id).members.create(
			body: {
				email_address: email,
				status: "subscribed",
				merge_fields: {FNAME: first_name, LNAME: last_name}
				}).body

		# put user's email in "No Boat" group
		gibbon.lists(list_id).members(member["id"]).update(
			body: {
				interests: {
					boat_started_id => false,
					boat_complete_id => false,
					boat_none_id => true
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
