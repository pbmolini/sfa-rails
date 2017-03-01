class PagesController < ApplicationController
  include HighVoltage::StaticPage
  before_action :authorize_page # This is NOT CanCan
  before_action :landing

  layout :layout_for_page

  add_breadcrumb Proc.new { |c| c.fa_icon('tachometer') }, '', if: :user_signed_in?

  def letsencrypt
    if Rails.env.production? && ENV['HEROKU_DEPLOYMENT'] == 'production'
      if params[:id] == ENV['LETS_ENCRYPT_ID']
        render text: ENV['LETS_ENCRYPT_CHALLENGE']
      else
        render text: 'Try again genius!'
      end
    else
      render text: 'Used only in production to validate SSL cert. (see http://collectiveidea.com/blog/archives/2016/01/12/lets-encrypt-with-a-rails-app-on-heroku)'
    end
  end

  private

  def landing
    if params[:id] == 'landing'
      @featured_boats = Boat.complete.featured.select { |boat| boat.can_be_published? }.first(3)
    end
  end

  # Custom authorization: CanCan skips this Controller
  def authorize_page
    if (params[:id] == 'dashboard' or params[:id] == 'welcome') and current_user.nil?
      session[:next] = request.fullpath
      puts session[:next]
      redirect_to new_user_session_path, alert: _("You have to log in to continue.")
    end
  end

  def layout_for_page
    case params[:id]
    when 'landing'
      'landing'
    # this was used for the old help (the one with affix)
    # when 'help/host', 'help/guest'
    #   'help'
    else
      'application'
    end
  end
end
