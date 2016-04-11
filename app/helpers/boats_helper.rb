module BoatsHelper

  # Returns boat's name if present, "boat" otherwise
  def name_or_boat_for boat
    boat.name.present? ? boat.name : _("boat")
  end

  def publish_boat_button boat
    simple_form_for boat, url: publish_boat_url(boat), method: :post, html: { class: 'pull-right' } do |f|
      f.button :button, class: 'btn btn-success btn-lg' do
        fa_icon('ship', text: _('Publish'), class: 'hidden-xs')
      end
    end
  end

  def text_for boat, field_name
  	if boat.send(field_name.to_s).blank?
  		content_tag :span, _("N/A"), class: 'incomplete-field'
  	else
      field = boat.send(field_name.to_s)
      if field_name == :fuel_type
  		  _(field).humanize
      else
        field
      end
  	end
  end

  def placeholder_url_for location
		height = '320'
		width = '480'
		text_size	= '100'
		text_color = 'fab647'
		background = 'd3d3d3'
		text = CGI.escape _("Edit to add\npictures\n ")

  	case location
  	when :boat_card
  		height = '250'
  		width = '300'
			text_size	= '42'
  	when :boat_show
  		height = '600'
  		width = '800'
			text_size	= '120'
  	end
  	
  	"//placeholdit.imgix.net/~text?txtsize=#{text_size}&txt=#{text}&w=#{width}&h=#{height}&bg=#{background}&txtclr=#{text_color}"
  end
end
