class ProductsController < ApplicationController
  before_action :authenticate_user!
  has_scope :by_types, type: :array
  has_scope :by_brands, type: :array

  # GET /products
  # GET /products.json
  def index
    @products = Product.all
    @product = Product.new
  end

  # GET /products/1
  # GET /products/1.json
  def show
    @product = Product.find(params[:id])
  end

  # GET /products/new
  def new
    @product = Product.new
  end

  # GET /products/1/edit
  def edit
    @product = Product.find(params[:id])
  end

  # POST /products
  # POST /products.json
  def create
    @product = Product.new(product_params)
    @productos = Product.all

    #Verificacion de que esten todos los campos llenos
    if params[:product][:nombre_producto] == "" || params[:product][:marca] == "" || params[:product][:tipo] == "" || params[:product][:ubicacion] == ""
      @titulo = "Creacion de producto"
      @mensaje = "Debe llenar todos los campos"
      @tipo = "warning"
    else
      if @product.stock.to_i < 0
        @titulo = "Creacion de producto"
        @mensaje = "La cantidad del producto debe ser mayor o igual a cero"
        @tipo = "warning"
      else
        #verficacion de la repetitividad de productos
        if !RepeticionNombre(@productos, @product.nombre_producto.upcase)#Retorna true si se encuentra
          @titulo = "Creacion de producto"
          @mensaje = "Ya existe un producto con ese nombre"
          @tipo = "warning"
        else
          respond_to do |format|
            if @product.save
              format.html {redirect_to @product, notice: "Producto creado correctamente"}
              format.json {render :show, status: :created, location: @product}
              format.js
              @titulo = "Creacion de producto"
              @mensaje = "Producto se ha creado correctamete"
              @tipo = "success"
            else
              format.html {render :new}
              format.json {render json: @product.errors, status: :unprocessable_entity}
              format.js
              @titulo = "Creacion de producto"
              @mensaje = "Ha ocurrido un error"
              @tipo = "danger"
            end
          end
        end
      end
    end
  end

  # PATCH /products/1
  # PATCH /products/1.json
  def update
    @product = Product.find(params[:id])
    @productos = Product.all
    if product_params[:nombre_producto] == "" || product_params[:marca] == "" || product_params[:tipo] == "" || product_params[:ubicacion] == ""
      @titulo_edit = "Edicion de producto"
      @mensaje_edit = "Debe llenar todos los campos"
      @tipo_edit = "warning"
    else
      #Varificacion de la existencia del nombre del producto
      if !RepetecionNombreUpdate(@productos, params[:product][:nombre_producto], params[:id])
        @titulo_edit = "Edicion de producto"
        @mensaje_edit = "Ya existe un producto con ese nombre"
        @tipo_edit = "warning"
      else
        respond_to do |format|
          if @product.update(product_params)
            format.html {redirect_to @product, notice: "Producto actualizado correctamente"}
            format.json {render :show, status: :created, location: @product}
            format.js
            @titulo_edit = "Edicion de producto"
            @mensaje_edit = "Producto se ha actualizado correctamete"
            @tipo_edit = "success"
          else
            format.html {render :new}
            format.json {render json: @product.errors, status: :unprocessable_entity}
            format.js
            @titulo_edit = "Edicion de producto"
            @mensaje_edit = "Ha ocurrido un error"
            @tipo_edit = "danger"
          end
        end
      end
    end
  end

  def destroy
    @product = Product.find(params[:id])
    stock =  @product.stock
    if stock.to_i > 0
      @titulo_del = "Borrar producto"
      @mensaje_del = "El producto seleccionado tiene una cantidad mayor a cero"
      @tipo_del = "warning"
    else
      if !ValidProdDel(params[:id])
        @titulo_del = "Borrar producto"
        @mensaje_del = "El producto seleccionado se encuentra en consumo"
        @tipo_del = "warning"
      else
        @product.destroy
        respond_to do |format|
          format.html{redirect_to product_path, notice: "Producto borrado con exito"}
          format.json{head :no_content}
          format.js
          @titulo_del = "Borrar producto"
          @mensaje_del = "Producto se ha borrado correctamente"
          @tipo_del = "success"
        end
      end
    end
  end

  private

  def product_params
    params.require(:product).permit(:nombre_producto, :tipo, :marca, :stock, :ubicacion)
  end

  def RepeticionNombre(lista_productos, nombre_prod_nuevo)
    val = true
    lista_productos.each do |producto|
      if producto.nombre_producto == nombre_prod_nuevo
        val = false
        break
      end
    end
    return val
  end

  def RepetecionNombreUpdate(lista_productos, nombre_prod, id_producto)
    val = true
    i = 0
    if lista_productos.length > 0
      lista_productos.each do |producto|
        if producto.nombre_producto == nombre_prod.upcase
          if producto.id.to_i != id_producto.to_i
            val = false
            break
          end
        end
      end
    end
    return val
  end

  def ValidProdDel(id_producto)
    val = true
    aux = Request.find_by_producto(id_producto)
    if aux != nil
      val = false
    end
    return val
  end
end
