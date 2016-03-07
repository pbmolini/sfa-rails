class Users::RegistrationsController < Devise::RegistrationsController
  before_filter :configure_sign_up_params, only: [:create]
  before_filter :configure_account_update_params, only: [:update]

  add_breadcrumb Proc.new { |c| c.fa_icon('tachometer') }, :dashboard_path, only: [:edit], if: :user_signed_in?

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  # def create
  #   super
  # end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # You can put the params you want to permit in the empty array.
  def configure_sign_up_params
    attributes = [:first_name, :last_name, :image]
    attributes.each do |a|
      devise_parameter_sanitizer.for(:sign_up) << a
    end
  end

  # You can put the params you want to permit in the empty array.
  def configure_account_update_params
    attributes = [:first_name, :last_name, :location, :bio, :phone, :birthdate, :image]
    attributes.each do |a|
      devise_parameter_sanitizer.for(:account_update) << a
    end
  end

  # The path used after sign up.
  def after_sign_up_path_for(resource)
    if booking_in_session?
      # redirect to edit_user_path to complete your profile 
      flash[:notice] = _("You must complete your profile to book a boat")
      edit_user_registration_path
    else
      welcome_path
    end
    # Before version Varazze it was
    # new_boat_path 
  end

  # The path used after updating profile.
  def after_update_path_for(resource)
    if booking_in_session? && resource.complete?
      create_booking_from_session # This returns a path
    else
      dashboard_path
    end
  end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end

  def update_resource(resource, params)
    # don't ask for password if registered with Facebook or if not updating password
    if (resource.uid && resource.provider) || (params[:current_password].empty? && params[:password].empty?)
      resource.update_without_password(params.except :current_password)
    else
      super(resource, params)
    end
  end
end
