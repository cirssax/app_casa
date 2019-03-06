class SituationsController < ApplicationController
  before_action :authenticate_user!

  # GET /situations
  # GET /situations.json
  def index
    if current_user.rol == 1
      @situations  = Situation.order(:id)
      @situation = Situation.new
    else
      @mensaje = "Seccion solo para administrador"
    end
  end

  # POST /situations
  # POST /situations.json
  def create
    @situation = Situation.new(situations_params)
    @situations = Situation.all
    #Verificacion de que los campos estén llenos
    if params[:situation][:descrip_estado_producto] == ""
      @titulo = "Creacion de estado de consumo"
      @mensaje = "Debe llenar todos los campos"
      @tipo = "warning"
      @icono = "icon fa fa-warning"
    else
      #Verificacion de la repeticion del nombre
      if !RepeticionEstadoCreate(@situations, params[:situation][:descrip_estado_producto])
        @titulo = "Creacion de estado de consumo"
        @mensaje = "Ya existe un estado de consumo con ese nombre"
        @tipo = "warning"
        @icono = "icon fa fa-warning"
      else
        respond_to do |format|
          if @situation.save
            format.js
            format.html {redirect_to @situation, notice: "Estado de consumo creado correctamente"}
            format.json {render :show, status: :created, location: @situation}
            @titulo = "Creacion de estado de consumo"
            @mensaje = "Se a creado el estado de consumo correctamente"
            @tipo = "success"
            @icono = "icon fa fa-check"
          else
            format.js
            format.html {render :new}
            format.json {render json: @situation.errors, status: :unprocessable_entity}
            @titulo = "Creacion de estado de consumo"
            @mensaje = "Ha ocurrido un error"
            @tipo = "danger"
            @icono = "icon fa fa-ban"
          end
        end
      end
    end
  end

  # GET /types/1/edit
  def edit
    @situation = Situation.find(params[:id])
  end


  def new
    @situation = Situation.new
  end

  # GET /types/new
  def update
    @situation = Situation.find(params[:id])
    @situations = Situation.all
    #Verificacion de que los campos esten llenos
    if params[:situation][:descrip_estado_producto] == ""
      @titulo_edit = "Edicion de estado de consumo"
      @mensaje_edit = "Debe llenar los campos"
      @tipo_edit = "warning"
      @icono_edit = "icon fa fa-warning"
    else
      #Varificacion de la existencia del nombre del producto
      if !RepetecionNombreUpdate(@situations, params[:situation][:descrip_estado_producto], params[:id])
        @titulo_edit = "Edicion de estado consumo"
        @mensaje_edit = "Ya existe estado de consumo bajo ese nombre"
        @tipo_edit = "warning"
        @icono_edit = "icon fa fa-warning"
      else
        respond_to do |format|
          if @situation.update(situations_params)
            format.html {redirect_to @situation, notice: "Estado de consumo actualizado correctamente"}
            format.json {render :show, status: :created, location: @situation}
            format.js
            @titulo_edit = "Edicion de estado de consumo"
            @mensaje_edit = "Se actualizo el estado de consumo correctamente"
            @tipo_edit = "success"
            @icono_edit = "icon fa fa-check"
          else
            format.html {render :new}
            format.json {render json: @situation.errors, status: :unprocessable_entity}
            format.js
            @titulo_edit = "Edicion de estado de consumo"
            @mensaje_edit = "Ha ocurrido un error"
            @tipo_edit = "danger"
            @icono_edit = "icon fa fa-ban"
          end
        end
      end
    end
  end

  def destroy
    @situation = Situation.find(params[:id])
    id = params[:id]
    @requests = Request.all
    if !RevisionDelete(id.to_i, @requests)
      @titulo_del = "Borrar estado de consumo"
      @mensaje_del = "El estado de consumo no se puede borrar ya que hay solicitudes asociadas"
      @tipo_del = "warning"
      @icono_del = "icon fa fa-warning"
    else
      @situation.destroy
      respond_to do |format|
        format.html{redirect_to situations_path, notice: "Estado de consumo borrado con exito"}
        format.json{head :no_content}
        format.js
        @titulo_del = "Borrar estado de consumo"
        @mensaje_del = "Estado de consumo borrado con exito"
        @tipo_del = "success"
        @icono_del = "icon fa fa-check"
      end
    end
  end

  private
  def situations_params
    params.require(:situation).permit(:descrip_estado_producto)
  end

  #Funcion para revisar las FK de las marcas
  def RevisionDelete(situation_id, listado_consultas)
    val = true
    listado_consultas.each do |consulta|
      if consulta.estado.to_i == situation_id
        val = false
        break
      end
    end
    return val
  end

  #Funcion para revisar la repetitividad del nombre de una marca
  def RepeticionEstadoCreate(lista_estados_consumo, nombre_estado_consumo)
    val = true
    lista_estados_consumo.each do |estado|
      if estado.descrip_estado_producto == nombre_estado_consumo.upcase
        val = false
        break
      end
    end
    return val
  end

  #Funcion para revisar la repetitividad de una marca en la actualizacion
  def RepetecionNombreUpdate(lista_estados_consumo, nombre_estado_consumo, id_estado_consumo)
    val = true
    lista_estados_consumo.each do |estado|
      if estado.descrip_estado_producto == nombre_estado_consumo.upcase
        if estado.id.to_i != id_estado_consumo.to_i
          val = false
          break
        end
      end
    end
    return val
  end

end
