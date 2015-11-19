ActiveAdmin.register Boat do

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
	permit_params :name, :manufacturer, :daily_price, :year, :model, :length, :guest_capacity, :boat_category_id, :description, :fuel_type, :with_license, :rental_type, :address, :horse_power, :user_id
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if resource.something?
#   permitted
# end

	belongs_to :user, optional: true

	menu label: "Boats", priority: 3

	index title: "Boats (#{Boat.count} total)" do
	  selectable_column
	  id_column
	  column :model
	  column :name
	  column :owner do |boat|
	  	boat.user.name
	  end
		column :address
		column :rental_type
	  column :pictures do |boat|
	  	boat.pictures.count
	  end
		column :daily_price
		column :with_license
		column :complete 
		actions
	end

	form do |f|
		f.inputs "Edit Boat" do
      f.input :model
			f.input :name
      f.input :manufacturer
      f.input :daily_price
      f.input :year
      f.input :length
      f.input :guest_capacity
      f.input :boat_category_id
      f.input :description
      f.input :fuel_type
      f.input :with_license
      f.input :rental_type
      f.input :address
      f.input :horse_power
		end
    f.actions
	end

	controller do
		def update
			# Remove the :user_id to enable update as a nested resource
			params.delete :user_id.to_s
			update!
		end
	end

end
