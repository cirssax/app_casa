class StatesController < ApplicationController
  before_action :authenticate_user!

  # GET /states
  # GET /states.json
  def index
    if current_user.rol == 1
      @states  = State.order(:id)
      @state = State.new
    else
      @mensaje = "Seccion solo para administrador"
    end
  end

  # POST /states
  # POST /states.json
  def create
    @state = State.new(states_params)
    @states = State.all
    #Verificacion de que los campos estén llenos
    if params[:state][:descrip_estado] == ""
      @titulo = "Creacion de estado"
      @mensaje = "Debe llenar todos los campos"
      @tipo = "warning"
    else
      #Verificacion de la repeticion del nombre
      if !RepeticionEstadoCreate(@states, params[:state][:descrip_estado])
        @titulo = "Creacion de estado"
        @mensaje = "Ya existe un estado de usuario con ese nombre"
        @tipo = "warning"
      else
        respond_to do |format|
          if @state.save
            format.js
            format.html {redirect_to @state, notice: "Estado de usuario creado correctamente"}
            format.json {render :show, status: :created, location: @state}
            @titulo = "Creacion de estado"
            @mensaje = "Se a creado el estado de usuario correctamente"
            @tipo = "success"
          else
            format.js
            format.html {render :new}
            format.json {render json: @state.errors, status: :unprocessable_entity}
            @titulo = "Creacion de estado"
            @mensaje = "Ha ocurrido un error"
            @tipo = "danger"
          end
        end
      end
    end
  end

  # GET /types/1/edit
  def edit
    @state = State.find(params[:id])
  end


  def new
    @state = State.new
  end

  # GET /types/new
  def update
    @state = State.find(params[:id])
    @states = State.all
    #Verificacion de que los campos esten llenos
    if params[:state][:descrip_estado] == ""
      @titulo_edit = "Edicion de estado"
      @mensaje_edit = "Debe llenar los campos"
      @tipo_edit = "warning"
    else
      #Varificacion de la existencia del nombre del producto
      if !RepetecionNombreUpdate(@states, params[:state][:descrip_estado], params[:id])
        @titulo_edit = "Edicion de estado"
        @mensaje_edit = "Ya existe estado de usuario bajo ese nombre"
        @tipo_edit = "warning"
      else
        respond_to do |format|
          if @state.update(states_params)
            format.html {redirect_to @state, notice: "Estado actualizado correctamente"}
            format.json {render :show, status: :created, location: @state}
            format.js {@titulo_edit = "Edicion de estado"
            @mensaje_edit = "Se actualizado el estado de usuario correctamente"
            @tipo_edit = "success"}

          else
            format.html {render :new}
            format.json {render json: @state.errors, status: :unprocessable_entity}
            format.js{
              @titulo_edit = "Edicion de estado"
              @mensaje_edit = "Ha ocurrido un error"
              @tipo_edit = "danger"}
          end
        end
      end
    end
  end

  def destroy
    @state = State.find(params[:id])
    id = params[:id]
    @users = User.all
    if !RevisionDelete(id.to_i, @users)
      @titulo_del = "Borrar estado"
      @mensaje_del = "El estado de usuario no se puede borrar ya que hay usuarios asociados"
      @tipo_del = "warning"
    else
      @type.destroy
      respond_to do |format|
        format.html{redirect_to type_path, notice: "Estado borrado con exito"}
        format.json{head :no_content}
        format.js
        @titulo_del = "Borrar estado"
        @mensaje_del = "Estado de usuario borrado con exito"
        @tipo_del = "success"
      end
    end
  end

  private
  def states_params
    params.require(:state).permit(:descrip_estado)
  end

  #Funcion para revisar las FK de las marcas
  def RevisionDelete(state_id, listado_usuarios)
    val = true
    listado_usuarios.each do |usuario|
      if usuario.estado.to_i == state_id
        val = false
        break
      end
    end
    return val
  end

  #Funcion para revisar la repetitividad del nombre de una marca
  def RepeticionEstadoCreate(lista_estados, nombre_estado)
    val = true
    lista_estados.each do |estado|
      if estado.descrip_estado == nombre_estado.upcase
        val = false
        break
      end
    end
    return val
  end

  #Funcion para revisar la repetitividad de una marca en la actualizacion
  def RepetecionNombreUpdate(lista_estados, nombre_estado, id_estado)
    val = true
    lista_estados.each do |estado|
      if estado.descrip_estado == nombre_estado.upcase
        if estado.id.to_i != id_estado.to_i
          val = false
          break
        end
      end
    end
    return val
  end

end
