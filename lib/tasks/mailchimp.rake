namespace :sfa do

  desc 'Set the Mailchimp Member Id to each user'
  task set_mc_member_id_to_users: :environment do
    list_id = ENV['MC_REGISTERED_USERS_LIST_ID']
    gibbon = Gibbon::Request.new
    list = gibbon.lists(list_id).members.retrieve(params: {count: (User.count + 42)})
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

end