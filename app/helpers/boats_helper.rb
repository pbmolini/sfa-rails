module BoatsHelper

  def publish_boat_button boat
    simple_form_for boat, url: publish_boat_url(boat), method: :post, remote: true, html: { class: 'pull-right' } do |f|
      f.button :button, class: 'btn btn-success btn-lg' do
        fa_icon('ship', text: 'Publish')
      end
    end
  end
end
