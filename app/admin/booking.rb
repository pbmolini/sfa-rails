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
	  column :messages, sortable: :messages do |b|
	  	link_to b.conversation.messages.count, admin_boat_booking_path(b.boat, b)
	  end
	  column :state, sortable: :state do |b| 
	  	b.aasm_state
	  end
	  column :cancellation_reason, sortable: false do |b|
	  	truncate b.cancellation_reason, length: 42
	  end

	  actions dropdown: true
	end

	sidebar "Conversation", only: [:show] do
    ul do
    	booking.conversation.messages.order('created_at ASC').each do |message|
      	li "<em>#{I18n.l(message.created_at, format: :long)}</em> <br> <strong>#{message.sender.name}</strong>: <p>#{message.body}</p>".html_safe, style: "list-style:none;"
      end 
      if booking.canceled?
      	li "<strong>Motivo della cancellazione:</strong>: <p>#{booking.cancellation_reason}</p>".html_safe, style: "list-style:none;"
      end
    end
  end

end
