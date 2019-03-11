class BrandsController < ApplicationController
  before_action :authenticate_user!


  # GET /brands
  # GET /bands.json
  def index
    if current_user.rol == 1
      @brands = Brand.order(:id)
      @brand = Brand.new
    else
      @mensaje = "Seccion exclusiva para administrador"
    end

    #Borrado del producto que lleva en aviso mas de dos días

  end

  # POST /brands
  # POST /brands.json
  def create
    @brand = Brand.new(brands_params)
    @brands = Brand.all
    #Verificacion de que los campos estén llenos
    if @brand.descrip_marca == ""
      @titulo = "Creacion de marca"
      @mensaje = "Debe llenar todos los campos"
      @tipo = "warning"
      @icono = "icon fa fa-warning"
    else
      #Verificacion de la repeticion del nombre
      if !RepeticionMarcaCreate(@brands, params[:brand][:descrip_marca])
        @titulo = "Creacion de marca"
        @mensaje = "Ya existe una marca con ese nombre"
        @tipo = "warning"
        @icono = "icon fa fa-warning"
      else
        respond_to do |format|
          if @brand.save
            format.js
            format.html {redirect_to @brand, notice: "Marca creada correctamente"}
            format.json {render :show, status: :created, location: @brand}
            @titulo = "Creacion de marca"
            @mensaje = "Se a creado la marca correctamente"
            @tipo = "success"
            @icono = "icon fa fa-check"
          else
            format.js
            format.html {render :new}
            format.json {render json: @brand.errors, status: :unprocessable_entity}
            @titulo = "Creacion de marca"
            @mensaje = "Ha ocurrido un error"
            @tipo = "danger"
            @icono = "icon fa fa-ban"
          end
        end
      end
    end
  end

  # GET /brands/1/edit
  def edit
    @brand = Brand.find(params[:id])
  end

  # GET /brands/new
  def new
    @brand = Brand.new
  end

  # PATCH /brands/1
  # PATCH /brands/1.json
  def update
    @brand = Brand.find(params[:id])
    @brands = Brand.all
    #Verificacion de que los campos esten llenos
    if params[:brand][:descrip_marca] == ""
      @titulo_edit = "Edicion de marca"
      @mensaje_edit = "Debe llenar todos los campos"
      @tipo_edit = "warning"
      @icono_edit = "icon fa fa-warning"
    else
      #Varificacion de la existencia del nombre del producto
      if !RepetecionNombreUpdate(@brands, params[:brand][:descrip_marca], params[:id])
        @titulo_edit = "Edicion de marca"
        @mensaje_edit = "Ya existe una marca bajo ese nombre"
        @tipo_edit = "warning"
        @icono_edit = "icon fa fa-warning"
      else
        respond_to do |format|
          if @brand.update(brands_params)
            format.html {redirect_to @brand, notice: "Marca actualizada correctamente"}
            format.json {render :show, status: :created, location: @brand}
            format.js
            @titulo_edit = "Edicion de marca"
            @mensaje_edit = "Se actualizado la marca correctamente"
            @tipo_edit = "success"
            @icono_edit = "icon fa fa-check"
          else
            format.html {render :new}
            format.json {render json: @brand.errors, status: :unprocessable_entity}
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
    @brand = Brand.find(params[:id])
    id = params[:id]
    @productos = Product.all
    if !RevisionDelete(id.to_i, @productos)
      @titulo_del = "Borrar marca"
      @mensaje_del = "La marca no se puede borrar ya que hay productos asociadas a ésta"
      @tipo_del = "warning"
      @icono_del = "icon fa fa-warning"
    else
      @brand.destroy
      respond_to do |format|
        format.html{redirect_to brand_path, notice: "Marca borrada con exito"}
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
  def brands_params
    params.require(:brand).permit(:descrip_marca)
  end

  #Funcion para revisar las FK de las marcas
  def RevisionDelete(brand_id, listado_productos)
    val = true
    listado_productos.each do |productos|
      if productos.marca.to_i == brand_id
        val = false
        break
      end
    end
    return val
  end

  #Funcion para revisar la repetitividad del nombre de una marca
  def RepeticionMarcaCreate(lista_marcas, nombre_marca)
    val = true
    lista_marcas.each do |marca|
      if marca.descrip_marca == nombre_marca.upcase
        val = false
        break
      end
    end
    return val
  end

  #Funcion para revisar la repetitividad de una marca en la actualizacion
  def RepetecionNombreUpdate(lista_marcas, nombre_marca, id_marca)
    val = true
    lista_marcas.each do |marca|
      if marca.descrip_marca == nombre_marca.upcase
        if marca.id.to_i != id_marca.to_i
          val = false
          break
        end
      end
    end
    return val
  end
end
