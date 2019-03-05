class RolesController < ApplicationController
  before_action :authenticate_user!

  # GET /roles
  # GET /roles.json
  def index
    if current_user.rol == 1
      @roles  = Role.order(:id)
      @role = Role.new
    else
      @mensaje = "Seccion solo para administrador"
    end
  end

  # POST /states
  # POST /states.json
  def create
    @role = Role.new(roles_params)
    @roles = Role.all
    #Verificacion de que los campos estén llenos
    if params[:role][:descrip_rol] == ""
      @titulo = "Creacion de rol"
      @mensaje = "Debe llenar todos los campos"
      @tipo = "warning"
    else
      #Verificacion de la repeticion del nombre
      if !RepeticionRolCreate(@roles, params[:role][:descrip_rol])
        @titulo = "Creacion de rol"
        @mensaje = "Ya existe un rol de usuario con ese nombre"
        @tipo = "warning"
      else
        respond_to do |format|
          if @role.save
            format.js
            format.html {redirect_to @role, notice: "Rol de usuario creado correctamente"}
            format.json {render :show, status: :created, location: @role}
            @titulo = "Creacion de rol"
            @mensaje = "Se a creado el rol de usuario correctamente"
            @tipo = "success"
          else
            format.js
            format.html {render :new}
            format.json {render json: @role.errors, status: :unprocessable_entity}
            @titulo = "Creacion de rol"
            @mensaje = "Ha ocurrido un error"
            @tipo = "danger"
          end
        end
      end
    end
  end

  # GET /types/1/edit
  def edit
    @role = Role.find(params[:id])
  end


  def new
    @role = Role.new
  end

  # GET /types/new
  def update
    @role = Role.find(params[:id])
    @roles = Role.all
    #Verificacion de que los campos esten llenos
    if params[:role][:descrip_rol] == ""
      @titulo_edit = "Edicion de rol"
      @mensaje_edit = "Debe llenar los campos"
      @tipo_edit = "warning"
    else
      #Varificacion de la existencia del nombre del producto
      if !RepetecionNombreUpdate(@roles, params[:role][:descrip_rol], params[:id])
        @titulo_edit = "Edicion de rol"
        @mensaje_edit = "Ya existe rol de usuario bajo ese nombre"
        @tipo_edit = "warning"
      else
        respond_to do |format|
          if @role.update(roles_params)
            format.html {redirect_to @role, notice: "Rol actualizado correctamente"}
            format.json {render :show, status: :created, location: @role}
            format.js {@titulo_edit = "Edicion de rol"
            @mensaje_edit = "Se actualizado el rol de usuario correctamente"
            @tipo_edit = "success"}

          else
            format.html {render :new}
            format.json {render json: @role.errors, status: :unprocessable_entity}
            format.js{
              @titulo_edit = "Edicion de rol"
              @mensaje_edit = "Ha ocurrido un error"
              @tipo_edit = "danger"}
          end
        end
      end
    end
  end

  def destroy
    @role = Role.find(params[:id])
    id = params[:id]
    @users = User.all
    if !RevisionDelete(id.to_i, @users)
      @titulo_del = "Borrar rol"
      @mensaje_del = "El rol de usuario no se puede borrar ya que hay usuarios asociados"
      @tipo_del = "warning"
    else
      @type.destroy
      respond_to do |format|
        format.html{redirect_to roles_path, notice: "Rol borrado con exito"}
        format.json{head :no_content}
        format.js
        @titulo_del = "Borrar rol"
        @mensaje_del = "Rol de usuario borrado con exito"
        @tipo_del = "success"
      end
    end
  end

  private
  def roles_params
    params.require(:role).permit(:descrip_rol)
  end

  #Funcion para revisar las FK de las marcas
  def RevisionDelete(role_id, listado_usuarios)
    val = true
    listado_usuarios.each do |usuario|
      if usuario.rol.to_i == role_id
        val = false
        break
      end
    end
    return val
  end

  #Funcion para revisar la repetitividad del nombre de una marca
  def RepeticionRolCreate(lista_roles, nombre_rol)
    val = true
    lista_roles.each do |rol|
      if rol.descrip_rol == nombre_rol.upcase
        val = false
        break
      end
    end
    return val
  end

  #Funcion para revisar la repetitividad de una marca en la actualizacion
  def RepetecionNombreUpdate(lista_roles, nombre_rol, id_rol)
    val = true
    lista_roles.each do |rol|
      if rol.descrip_rol == nombre_rol.upcase
        if rol.id.to_i != id_rol.to_i
          val = false
          break
        end
      end
    end
    return val
  end

end
