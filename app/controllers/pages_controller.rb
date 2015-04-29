class PagesController < ApplicationController
  include HighVoltage::StaticPage

  layout :layout_for_page

  private

  def layout_for_page
    case params[:id]
    when 'landing'
      'landing'
    when 'help/host', 'help/guest'
      'help'
    else
      'application'
    end
  end
end
