ActiveAdmin.register BoatFeaturesSet do

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
	menu false

	form do |f|
		f.inputs "Edit Boat features set" do
			BoatFeaturesSet::FEATURES.each { |bf| f.input bf }
		end
    f.actions
	end

end
