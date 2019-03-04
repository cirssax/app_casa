class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :allow_without_password, only: [:update]
  # GET /users
  # GET /users.json
  def index
    if current_user.rol == 1
      @users = User.order(:id)
    else
      @mensaje = "Seccion exclusiva para administrador"
    end
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(users_params)
    @users = User.all
    #Verificacion de que los campos estén llenos
    if params[:user][:nombre_usuario] == "" || params[:user][:apellidos_usuario] == "" || params[:user][:email] == "" || params[:user][:rol] == "" || params[:user][:estado] == ""
      @titulo = "Creacion de usuario"
      @mensaje = "Debe llenar todos los campos"
      @tipo = "warning"
    else
      #Verificacion de la password
      if params[:user][:password] != params[:user][:password_confirmation]
        @titulo = "Creacion de usuario"
        @mensaje = "Las contraseñas son distintas"
        @tipo = "warning"
      else
        #Verificacion de la repeticion del nombre
        if !RepeticionUsuarioCreate(@users, @user.nombre_usuario, @user.apellidos_usuario)
          @titulo = "Creacion de usuario"
          @mensaje = "Ya existe un usuario con ese nombre y apellido"
          @tipo = "warning"
        else
          if !RepeticionEmailCreate(@users, @user.email)
            @titulo = "Creacion de usuario"
            @mensaje = "Ya existe un usuario con correo electrónico registrado"
            @tipo = "warning"
          else
            if !RepeticionLoginCrete(@users, params[:user][:login])
              @titulo = "Creacion de usuario"
              @mensaje = "Ya existe un usuario con ese login"
              @tipo = "warning"
            else
              respond_to do |format|
                if @user.save
                  format.js
                  format.html {redirect_to @user, notice: "Usuario creado correctamente"}
                  format.json {render :show, status: :created, location: @user}
                  @titulo = "Creacion de usuario"
                  @mensaje = "Se a creado el usuario correctamente"
                  @tipo = "success"
                else
                  format.js
                  format.html {render :new}
                  format.json {render json: @user.errors, status: :unprocessable_entity}
                  @titulo = "Creacion de usuario"
                  @mensaje = "Ha ocurrido un error"
                  @tipo = "danger"
                end
              end
            end
          end
        end
      end
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # GET /users/1/state
  def state
    @user = User.find(params[:id])
    respond_to do |format|
      #Caso en que se tiene que desactivar el usuario
      if params[:estado] == "1"
        format.html {redirect_to @user, notice: "Usuario actualizado correctamente"}
        format.json {render :show, status: :created, location: @user}
        format.js
        @titulo_estado = "Cambio de estado"
        @mensaje_estado = "Usuario desactivado"
        @tipo_estado = "success"
        @user.update_attribute :estado, "2"
      else
        #Caso en que se tiene que activar el usuario
        if params[:estado] == "2"
          format.html {redirect_to @user, notice: "Usuario actualizado correctamente"}
          format.json {render :show, status: :created, location: @user}
          format.js
          @titulo_estado = "Cambio de estado"
          @mensaje_estado = "Usuario activado"
          @tipo_estado = "success"
          @user.update_attribute :estado, "1"
        else
          format.html {render :new}
          format.json {render json: @user.errors, status: :unprocessable_entity}
          format.js
          @titulo_estado = "Cambio de estado"
          @mensaje_estado = "Ha ocurrido un error"
          @tipo_estado = "danger"
        end
      end
    end
  end


  # GET /users/new
  def new
    @user = User.new
  end

  def update
    @user = User.find(params[:id])
    @users = User.all
    #Verificacion de que esten llenos los campos
    if params[:user][:nombre_usuario] == "" || params[:user][:apellidos_usuario] == "" || params[:user][:email] == "" || params[:user][:rol] == "" || params[:user][:estado] == ""
      @titulo_edit = "Edicion de usuario"
      @mensaje_edit = "Debe llenar todos los campos"
      @tipo_edit = "warning"
    else
      #En el caso de que halla cambio de pass, verificacion que esten bien escritas ambas
      if params[:user][:password] != params[:user][:password_confirmation]
        @titulo_edit = "Edicion de usuario"
        @mensaje_edit = "La contraseña nueva es diferente de la que se confirma"
        @tipo_edit = "warning"
      else
        #Varificacion de la existencia de un usuario con ese nombre
        if !RepetecionUsuarioUpdate(@users, params[:user][:nombre_usuario], params[:user][:apellidos_usuario] ,params[:id])
          @titulo_edit = "Edicion de usuario"
          @mensaje_edit = "Ya existe un usuario con ese nombre y/o apellidos"
          @tipo_edit = "warning"
        else
          if !RepetecionEmailUpdate(@users, params[:user][:email], params[:id])
            @titulo_edit = "Edicion de usuario"
            @mensaje_edit = "Ya existe un usuario con ese correo electrónico"
            @tipo_edit = "warning"
          else
            if !RepeticionLoginUpdate(@users, params[:user][:login], params[:id])
              @titulo_edit = "Edicion de usuario"
              @mensaje_edit = "Ya existe un usuario asignado a ese login"
              @tipo_edit = "warning"
            else
              respond_to do |format|
                if @user.update(users_params)
                  format.html {redirect_to @user, notice: "Usuario actualizado correctamente"}
                  format.json {render :show, status: :created, location: @user}
                  format.js
                  @titulo_edit = "Edicion de usuario"
                  @mensaje_edit = "Se actualizado el usuario correctamente"
                  @tipo_edit = "success"
                else
                  format.html {render :new}
                  format.json {render json: @user.errors, status: :unprocessable_entity}
                  format.js
                  @titulo_edit = "Edicion de usuario"
                  @mensaje_edit = "Ha ocurrido un error"
                  @tipo_edit = "danger"
                end
              end
            end
          end
        end
      end
    end
  end

  private
  def users_params
    params.require(:user).permit(:password_confirmation, :email, :password, :nombre_usuario, :apellidos_usuario, :login, :rol, :estado)
  end

  def allow_without_password
    if params[:user][:password].blank? && params[:user][:password_confirmation].blank?
      params[:user].delete(:password)
      params[:user].delete(:password_confirmation)
    end
  end

  #Funcion para revisar la repetitividad del nombre de un usuario
  def RepeticionUsuarioCreate(lista_usuarios, nombre_usuario, apellidos_usuarios)
    val = true
    lista_usuarios.each do |usuario|
      if usuario.nombre_usuario == nombre_usuario.upcase
        if usuario.apellidos_usuario == apellidos_usuarios.upcase
          val = false
          break
        end
      end
    end
    return val
  end

  #Funcion para revisar la repetitividad del nombre de un usuario en la actualizacion
  def RepetecionUsuarioUpdate(lista_usuario, nombre_usuario, apellidos_usuario ,id_usuario)
    val = true
    lista_usuario.each do |usuario|
      if usuario.nombre_usuario == nombre_usuario.upcase && usuario.apellidos_usuario == apellidos_usuario.upcase &&  usuario.id.to_i != id_usuario.to_i
        val = false
        break
      end
    end
    return val
  end

  #Funcion para revisar la repetitividad del login de un usuario en su creacion
  def RepeticionLoginCrete(lista_usuario, login)
    val = true
    lista_usuario.each do |usuario|
      if usuario.login == login.upcase
        val = false
        break
      end
    end
    return val
  end

  #Funcion para revisar la repetitividad del login de un usuario al actualizarlo
  def RepeticionLoginUpdate(lista_usuario, login, id)
    val = true
    lista_usuario.each do |usuario|
      if usuario.login == login.upcase
        if usuario.id.to_i != id.to_i
          val = false
          break
        end
      end
    end
    return val
  end

  #Funcion para revisar la repetitividad del correo del usuario al actualizarlo
  def RepetecionEmailUpdate(lista_usuario, email, id)
    val = true
    lista_usuario.each do |usuario|
      if usuario.email == email.downcase
        if usuario.id.to_i != id.to_i
          val = false
          break
        end
      end
    end
    return val
  end

  #Funcion para revisar la repetitividad del correo del usuario al crearlo
  def RepeticionEmailCreate(lista_usuario, email)
    val = true
    lista_usuario.each do |usuario|
      if usuario.email == email.downcase
        val = false
        break
      end
    end
    return val
  end
end
