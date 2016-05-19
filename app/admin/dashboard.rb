ActiveAdmin.register_page "Dashboard" do

  menu priority: 1, label: proc{ I18n.t("active_admin.dashboard") }

  content title: proc{ I18n.t("active_admin.dashboard") } do
    
    columns do
      column do
        panel "Benvenuto!" do
          h1 "Questa è l'interfaccia di Amministrazione di <strong>Sea for All</strong>".html_safe
          h2 "Ci sono #{User.count} utenti iscritti, l'ultimo si è iscritto #{time_ago_in_words(User.last.created_at)} fa"
          h2 "Le barche iscritte sono #{Boat.count}, di cui #{Boat.complete.count} completate"
        end
      end
    end

    columns do
      column do
        panel "Gli ultimi 5 utenti iscritti" do
          ul do
            User.last(5).reverse.map do |user|
              li "#{link_to(user.name, admin_user_path(user))}, iscritto #{time_ago_in_words(user.created_at)} fa".html_safe
            end
          end
        end
      end

      column do
        panel "Le ultime 5 barche completate" do
          ul do
            Boat.complete.last(5).reverse.map do |boat|
              li "#{link_to(boat.name, admin_boat_path(boat))}, di #{link_to(boat.user.name, admin_user_path(boat.user))}".html_safe
            end
          end
        end
      end

      column do
        panel "Le ultime 5 prenotazioni" do
          ul do
            Booking.last(5).reverse.map do |booking|
              li "Per #{link_to(booking.boat.name, admin_boat_booking_path(booking.boat, booking))}, fatto da #{link_to(booking.user.name, admin_user_path(booking.user))}".html_safe
            end
          end
        end
      end
      column do
        panel "Delayed Jobs" do
          now = Time.now.getgm
          ul do
            li do
              jobs = Delayed::Job.where('failed_at is not null').count(:id)
              link_to "#{jobs} failing jobs", admin_jobs_path(q: {failed_at_is_not_null: true}), style: 'color: red'
            end
            li do
              jobs = Delayed::Job.where('run_at <= ?', now).count(:id)
              link_to "#{jobs} late jobs", admin_jobs_path(q: {run_at_lte: now.to_s(:db)}), style: 'color: hsl(40, 100%, 40%)'
            end
            li do
              jobs = Delayed::Job.where('run_at >= ?', now).count(:id)
              link_to "#{jobs} scheduled jobs", admin_jobs_path(q: {run_at_gte: now.to_s(:db)}), style: 'color: green'
            end
          end
        end
      end
    end

  end # content
end
