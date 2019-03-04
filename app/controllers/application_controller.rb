class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  before_action :permitted_parameters, if: :devise_controller?

  auto_session_timeout 2.minutes #control de la sesion inactiva con máximo 2 minutos

  def inicio

  end

  def about

  end

  def contact

  end
  def permitted_parameters
    added_attrs = [:email, :password, :password_confirmation,:nombre_usuario, :apellidos_usuario, :login ,:rol, :estado ]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
  end



end
