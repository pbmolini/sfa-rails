ActiveAdmin.register User do

	permit_params :first_name, :last_name, :email, :location, :bio, :phone, :birthdate

	menu priority: 2

	index title: "Users (#{User.count} total)" do
	  selectable_column
	  id_column
	  column :first_name
	  column :last_name
	  column :email
	  column :boats do |user|
	  	link_to user.boats.count, admin_user_boats_path(user)
	  end
		column :location
		column :phone 
		column :birthdate
		actions dropdown: true
	end

	form do |f|
		f.inputs "Edit User" do
			f.input :first_name
			f.input :last_name
			f.input :email
			f.input :location
			f.input :bio
			f.input :phone
			f.input :birthdate, as: :datepicker
		end
    f.actions
	end

	sidebar "Boats", only: [:show, :edit] do
		h3 link_to 'All boats', admin_user_boats_path(user)
    ul do
    	user.boats.each do |boat|
      	li link_to(boat.name.present? ? boat.name : 'No_name', admin_user_boat_path(user, boat))
      end
    end
  end

end
