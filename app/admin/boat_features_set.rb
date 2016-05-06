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

	sidebar "Related stuff", only: [:show, :edit] do
    ul do
      li "Boat: #{link_to boat_features_set.boat.name, admin_boat_path(boat_features_set.boat)}".html_safe
      li "Owner: #{link_to boat_features_set.boat.user.name, admin_user_path(boat_features_set.boat.user)}".html_safe
    end
  end

end
