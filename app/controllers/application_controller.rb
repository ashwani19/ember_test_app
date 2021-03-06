class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  #protect_from_forgery with: :exception
   respond_to :html, :json
  helper_method :current_user_json

  before_filter :update_sanitized_params, if: :devise_controller?

   rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end
  def current_user_json
    if current_user
      user=Hash.new
      user["id"]=current_user.id
      user["email"]=current_user.email
      user["role"]=current_user.roles.first.name

     user.to_json
    else
      {}.to_json
    end
  end

  def update_sanitized_params
    devise_parameter_sanitizer.for(:sign_up) {|u| u.permit(:name, :email, :password, :password_confirmation)}
  end
end
