class TypesController < ApplicationController
  before_action :authenticate_user!

  # GET /types
  # GET /types.json
  def index
    if current_user.rol == 1
      @types  = Type.order(:id)
      @type = Type.new
    else
      @mensaje = "Seccion solo para administrador"
    end
  end

  # POST /types
  # POST /types.json
  def create
    @type = Type.new(types_params)
    @types = Type.all
    #Verificacion de que los campos estén llenos
    if @type.descrip_tipo == ""
      @titulo = "Creacion de tipo"
      @mensaje = "Debe llenar todos los campos"
      @tipo = "warning"
      @icono = "icon fa fa-warning"
    else
      #Verificacion de la repeticion del nombre
      if !RepeticionMarcaCreate(@types, params[:type][:descrip_tipo])
        @titulo = "Creacion de tipo"
        @mensaje = "Ya existe una tipo con ese nombre"
        @tipo = "warning"
        @icono = "icon fa fa-warning"
      else
        respond_to do |format|
          if @type.save
            format.js
            format.html {redirect_to @type, notice: "Marca creada correctamente"}
            format.json {render :show, status: :created, location: @type}
            @titulo = "Creacion de tipo"
            @mensaje = "Se a creado el tipo correctamente"
            @tipo = "success"
            @icono = "icon fa fa-check"
          else
            format.js
            format.html {render :new}
            format.json {render json: @type.errors, status: :unprocessable_entity}
            @titulo = "Creacion de tipo"
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
    @type = Type.find(params[:id])
  end


  def new
    @type = Type.new
  end

  # GET /types/new
  def update
    @type = Type.find(params[:id])
    @types = Type.all
    #Verificacion de que los campos esten llenos
    if params[:type][:descrip_tipo] == ""
      @titulo_edit = "Edicion de tipo"
      @mensaje_edit = "Debe llenar los campos"
      @tipo_edit = "warning"
      @icono_edit = "icon fa fa-warning"
    else
      #Varificacion de la existencia del nombre del producto
      if !RepetecionNombreUpdate(@types, params[:type][:descrip_tipo], params[:id])
        @titulo_edit = "Edicion de tipo"
        @mensaje_edit = "Ya existe un tipo bajo ese nombre"
        @tipo_edit = "warning"
        @icono_edit = "icon fa fa-warning"
      else
        respond_to do |format|
          if @type.update(types_params)
            format.html {redirect_to @type, notice: "Tipo actualizado correctamente"}
            format.json {render :show, status: :created, location: @type}
            format.js
            @titulo_edit = "Edicion de marca"
            @mensaje_edit = "Se actualizado la marca correctamente"
            @tipo_edit = "success"
            @icono_edit = "icon fa fa-check"
          else
            format.html {render :new}
            format.json {render json: @type.errors, status: :unprocessable_entity}
            format.js
            @titulo_edit = "Edicion de marca"
            @mensaje_edit = "Ha ocurrido un error"
            @tipo_edit = "danger"
            @icono_edit = "icon fa fa-ban"
          end
        end
      end
    end
  end

  def destroy
    @type = Type.find(params[:id])
    id = params[:id]
    @productos = Product.all
    if !RevisionDelete(id.to_i, @productos)
      @titulo_del = "Borrar marca"
      @mensaje_del = "El tipo no se puede borrar ya que hay productos asociadas a éste"
      @tipo_del = "warning"
      @icono_del = "icon fa fa-warning"
    else
      @type.destroy
      respond_to do |format|
        format.html{redirect_to type_path, notice: "Tipo borrado con exito"}
        format.json{head :no_content}
        format.js
        @titulo_del = "Borrar marca"
        @mensaje_del = "Marca borrada con exito"
        @tipo_del = "success"
        @icono_del = "icon fa fa-check"
      end
    end
  end

  private
  def types_params
    params.require(:type).permit(:descrip_tipo)
  end

  #Funcion para revisar las FK de las marcas
  def RevisionDelete(type_id, listado_productos)
    val = true
    listado_productos.each do |productos|
      if productos.tipo.to_i == type_id
        val = false
        break
      end
    end
    return val
  end

  #Funcion para revisar la repetitividad del nombre de una marca
  def RepeticionMarcaCreate(lista_tipos, nombre_tipo)
    val = true
    lista_tipos.each do |tipo|
      if tipo.descrip_tipo == nombre_tipo.upcase
        val = false
        break
      end
    end
    return val
  end

  #Funcion para revisar la repetitividad de una marca en la actualizacion
  def RepetecionNombreUpdate(lista_tipos, nombre_tipo, id_tipo)
    val = true
    lista_tipos.each do |tipo|
      if tipo.descrip_tipo == nombre_tipo.upcase
        if tipo.id.to_i != id_tipo.to_i
          val = false
          break
        end
      end
    end
    return val
  end

end
