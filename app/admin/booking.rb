ActiveAdmin.register Booking do

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
# permit_params :list, :of, :attributes, :on, :model
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if resource.something?
#   permitted
# end

	belongs_to :boat, optional: true
	
	# Only one belongs_to is possible (see https://github.com/activeadmin/activeadmin/issues/221)
	# belongs_to :user, optional: true

	menu label: "Bookings", priority: 4

	index title: "Bookings (#{Booking.count})" do |booking|
		selectable_column
	  id_column
	  column :start_time
	  column :end_time
	  column :people_on_board
	  column :host, sortable: :host do |b|
	  	link_to b.boat.user.name, admin_user_path(b.boat.user)
	  end
	  column :guest, sortable: :guest do |b|
	  	link_to b.user.name, admin_user_path(b.user)
	  end
	  column :state, sortable: :state do |b| 
	  	b.aasm_state
	  end
	  column :cancellation_reason, sortable: false do |b|
	  	truncate b.cancellation_reason, length: 42
	  end

	  actions dropdown: true
	end

end
