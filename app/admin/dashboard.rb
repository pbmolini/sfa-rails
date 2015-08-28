ActiveAdmin.register_page "Dashboard" do

  menu priority: 1, label: proc{ I18n.t("active_admin.dashboard") }

  content title: proc{ I18n.t("active_admin.dashboard") } do
    
    columns do
      column do
        panel "Recent Boats" do
          ul do
            Boat.last(5).map do |boat|
              li link_to(boat.name, admin_boat_path(boat))
            end
          end
        end
      end

      column do
        panel "Info" do
          para "Welcome to ActiveAdmin."
        end
      end
    end
  end # content
end
