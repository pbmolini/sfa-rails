class ApplicationController < ActionController::Base
  before_filter :set_gettext_locale
  before_action :set_locale

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  authorize_resource unless: :devise_or_pages_or_admin_controller?
  check_authorization unless: :devise_or_pages_or_admin_controller?

  rescue_from CanCan::AccessDenied do |exception|
    if current_user.nil?
      session[:next] = request.fullpath
      puts session[:next]
      redirect_to login_url, :alert => _("You have to log in to continue.")
    else
      #render :file => "#{Rails.root}/public/403.html", :status => 403
      if request.env["HTTP_REFERER"].present?
        redirect_to :back, :alert => exception.message
      else
        redirect_to root_url, :alert => exception.message
      end
    end
  end

  # Devise wants these methods here, see:
  # https://github.com/plataformatec/devise/wiki/How-To:-Redirect-to-a-specific-page-after-a-successful-sign-in-or-sign-out
  def after_sign_in_path_for(resource)
    if resource.is_a? ::AdminUser
      admin_root_path
    else
      dashboard_path
    end
  end

  def after_sign_out_path_for(resource_or_scope)
    if resource_or_scope.is_a? ::AdminUser
      admin_root_path
    else
      root_path
    end
  end

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options(options = {})
    # Passing the locale in the URL when inside the admin interface is a mess
    if self.class.ancestors.include?(ActiveAdmin::BaseController)
      options
    else
      { locale: I18n.locale }.merge options
    end
  end

  private

  def devise_or_pages_or_admin_controller?
    devise_controller? || is_a?(::PagesController) || admin_controller?
  end

  def admin_controller?
    self.class.ancestors.include?(ActiveAdmin::BaseController) || self.class.ancestors.include?(ActiveAdmin::Devise::Controller)
  end

end
