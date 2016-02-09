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
      # Store the original requests
      if is_booking_creation?
        session[:booking_request_params] = request.request_parameters
        session[:booking_path_params] = request.path_parameters
      end
      # pry-byebug
      redirect_to new_user_session_path, notice: _("You have to log in to continue")
    else
      #render :file => "#{Rails.root}/public/403.html", :status => 403
      if request.env["HTTP_REFERER"].present?
        redirect_to :back, alert: exception.message
      else
        redirect_to root_url, alert: exception.message
      end
    end
  end

  # Devise wants these methods here, see:
  # https://github.com/plataformatec/devise/wiki/How-To:-Redirect-to-a-specific-page-after-a-successful-sign-in-or-sign-out
  def after_sign_in_path_for(resource)
    if resource.is_a? ::AdminUser
      admin_root_path
    else
      if booking_in_session?
        create_booking_from_session # This returns a path
      else
        dashboard_path
      end
    end
  end

  def after_sign_out_path_for(resource_or_scope)
    if resource_or_scope.is_a? ::AdminUser
      admin_root_path
    else
      # root_path
      # TODO: How to check if the user can access request.referrer? 
      request.referrer
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

  protected

  # Check if there is a booking in the session, i.e. the user tried to create a
  # Booking when not logged in.
  def booking_in_session?
    session[:booking_request_params].present? && session[:booking_path_params].present?
  end

  # Create a Booking in case the user started the booking creation
  # when not logged in, and return a path
  def create_booking_from_session
    # get the boat from the retained request path
    boat = Boat.find session[:booking_path_params]['boat_id']
    # create the booking from the retained request params
    booking = boat.bookings.build(session[:booking_request_params]['booking'])
    booking.user = current_user # done manually because user_id is not in params
    if booking.save
      # clear session
      clear_session
      # and go to the booking
      flash[:notice] = _("You have successfully requested a booking to %{host_name}") %{host_name: boat.user.name}
      boat_booking_path(boat, booking)
    else
      flash[:alert] = _("A problem occurred with your booking. Please try again")
      boat_path boat
    end
  end

  # Delete all the keys in the session hash that have been used for
  # storing temporary data
  def clear_session
    session.delete :booking_request_params
    session.delete :booking_path_params
  end

  private

  def devise_or_pages_or_admin_controller?
    devise_controller? || is_a?(::PagesController) || admin_controller?
  end

  def admin_controller?
    self.class.ancestors.include?(ActiveAdmin::BaseController) || self.class.ancestors.include?(ActiveAdmin::Devise::Controller)
  end

  # Returns true if there has been a POST request for creating a Booking
  def is_booking_creation?
    request.post? && request.request_parameters['booking'].present?
  end

end
