namespace :sfa do
  desc 'Set the Mailchimp Member Id to each user'
  task set_mc_member_id_to_users: :environment do
    list_id = ENV['MC_REGISTERED_USERS_LIST_ID']
    gibbon = Gibbon::Request.new
    list = gibbon.lists(list_id).members.retrieve(params: {count: (User.count + 42)}).body
    h = {} # will be something like {"ciao@example.com" => "ID"}
    list["members"].each {|member| h[member["email_address"]] = member["id"]}
    puts "#{h.count} members found in this list"
    User.find_each do |user|
      unless user.mc_member_id
        if h[user.email]
          puts "Setting id #{h[user.email]} for #{user.email}"
          user.update_attribute(:mc_member_id, h[user.email])
        else
          puts "No Mailchimp member found for User with id #{user.id} and email #{user.email}"
        end
      end
    end
  end

  desc 'Update the Mailchimp group of each user'
  task update_mc_user_groups: :environment do
    list_id = ENV['MC_REGISTERED_USERS_LIST_ID']
		boat_complete_id = ENV['MC_BOAT_COMPLETE_GROUP_ID']
		boat_started_id = ENV['MC_BOAT_STARTED_GROUP_ID']
		boat_none_id = ENV['MC_BOAT_NONE_GROUP_ID']

		gibbon = Gibbon::Request.new
    User.find_each do |user|
      if user.mc_member_id
        # put user's email in the corresponding group
        gibbon.lists(list_id).members(user.mc_member_id).update(
          body: {
            interests: {
              boat_started_id => boat_started,
              boat_complete_id => boat_complete,
              boat_none_id => boat_none
            }
          })
      end
    end
  end
end
