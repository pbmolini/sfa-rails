class PagesController < ApplicationController
  include HighVoltage::StaticPage
  before_action :authorize_page # This is NOT CanCan

  layout :layout_for_page

  private

  # Custom authorization: CanCan skips this Controller
  def authorize_page
    if params[:id] == 'dashboard' and current_user.nil?
      session[:next] = request.fullpath
      puts session[:next]
      redirect_to new_user_session_path, alert: _("You have to log in to continue.")
    end
  end

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
