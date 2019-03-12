# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]
  #
  # Control de sesion
  auto_session_timeout_actions

  def active
   render_session_status
  end

  def timeout
    render_session_timeout
  end

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  def create
    login = params[:user][:login]
    pass = params[:user][:password]

    #eliminar los espacios vacios al inicio y fin
    pass.strip
    login.strip
    if pass == "" || login == ""
      flash[:danger] = "Ingrese datos"
      redirect_to new_user_session_url
    else
      user = User.find_by_login(login.upcase)
      if user
        if user.estado == 2
          flash[:danger] = "Usuario inactivo"
          redirect_to new_user_session_url
        else
          if user.valid_password?(params[:user][:password])
            sign_in_and_redirect user
          else
            flash[:warning] = "Datos incorrectos"
            redirect_to new_user_session_url
          end
        end
      else
        usuario = User.find_by_email(login.downcase)
        if usuario
          if usuario.estado == 2
            flash[:danger] = "Usuario inactivo"
            redirect_to new_user_session_url
          else
            if usuario.valid_password?(params[:user][:password])
              sign_in_and_redirect usuario
            else
              flash[:warning] = "Datos incorrectos"
              redirect_to new_user_session_url
            end
          end
        else
          flash[:success] = "Datos incorrectos"
          redirect_to new_user_session_url
        end
      end
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
