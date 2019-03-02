# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  def create
    login = params[:user][:login]
    user = User.find_by(login: login.upcase)
    if user
      if user.estado == 2
        flash[:danger] = "Usuario inactivo"
        redirect_to new_user_session_url
      else
        if params[:user][:password] == "" || params[:user][:login] == ""
          flash[:warning] = "Ingrese su correo y contraseña"
          redirect_to new_user_session_url
        end
        if user.valid_password?(params[:user][:password])
          sign_in_and_redirect user
        end
      end
    else
      flash[:success] = "Ingrese sus datos"
      redirect_to new_user_session_url
    end
  end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
