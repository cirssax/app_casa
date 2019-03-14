class RequestsController < ApplicationController
  before_action :authenticate_user!


  # GET /requests
  # GET /requests.json
  def index
    @requests = Request.all
    @products = Product.all
  end

  def create
    @request = Request.new(requests_params)
    if requests_params[:cantidad] == "" || requests_params[:cantidad] == nil
      @titulo = "Nuevo consumo"
      @mensaje = "Debe llenar todos los campos"
      @tipo = "warning"
      @icono = "icon fa fa-warning"
    else
      cantidad = requests_params[:cantidad]
      cantidad = cantidad.to_i
      if cantidad <= 0
        @titulo = "Nuevo consumo"
        @mensaje = "La cantidad debe ser mayor estricta a cero"
        @tipo = "warning"
        @icono = "icon fa fa-warning"
      else
        @requests = Request.all
        producto = ($id).to_i
        producto = producto.to_i
        if !RepeticionConsumoCreate(@requests, producto)
          @titulo = "Nuevo consumo"
          @mensaje = "El producto seleccionado ya está en consumo"
          @tipo = "warning"
          @icono = "icon fa fa-warning"
        else
          if !Cantidad(cantidad, producto)
            @titulo = "Nuevo consumo"
            @mensaje = "La cantidad es demasiado grande o el stock no da abasto"
            @tipo = "warning"
            @icono = "icon fa fa-warning"
          else
            @request.fecha = DateTime.now
            @request.estado = 1
            @request.producto = producto
            @request.usuario = current_user.id

            @product = Product.find($id)
            stock = @product.stock
            nuevo = stock.to_i - @request.cantidad.to_i
            @product.update_attribute :stock, nuevo

            respond_to do |format|
              if @request.save
                format.js
                format.html {redirect_to @request, notice: "Producto en consumo registrado"}
                format.json {render :show, status: :created, location: @request}
                @titulo = "Nuevo consumo"
                @mensaje = "Producto en consumo añadido"
                @tipo = "success"
                @icono = "icon fa fa-check"
              else
                format.js
                format.html {render :new}
                format.json {render json: @request.errors, status: :unprocessable_entity}
                @titulo = "Nuevo consumo"
                @mensaje = "Ha ocurrido un error"
                @tipo = "danger"
                @icono = "icon fa fa-ban"
              end
            end
          end
        end
      end
    end
  end

  def new

  end

  def edit
    @request = Request.new
    $id = params[:id]
  end

  def update

  end

  def show

  end

  def destroy

  end

  def change_state
    @request = Request.find(params[:iden])
    puts Product.find(@request.producto.to_i).nombre_producto.to_s
    respond_to do |format|
      format.html {redirect_to @request, notice: "Producto consumido"}
      format.json {render :show, status: :created, location: @request}
      format.js
      @titulo_estado = "Producto consumido"
      @mensaje_estado = "Producto consumido"
      @tipo_estado = "success"
      @icono_estado = "icon fa fa-check"
      @request.update_attribute :estado, "2"
      @request.update_attribute :fecha, DateTime.now
      @request.update_attribute :usuario, current_user.id

    end
  end

  private
  def requests_params
    params.require(:request).permit(:fecha, :cantidad, :estado, :producto, :usuario)
  end

  #Funcion para revisar la repetitividad del nombre de una marca
  def RepeticionConsumoCreate(lista_consumo, producto_consumo)
    val = true
    lista_consumo.each do |consumo|
      if consumo.producto.to_i == producto_consumo
        if consumo.estado.to_i == 1
          val = false
          break
        end
      end
    end
    return val
  end

  #Funcion para validad que la cantidad sea prudente
  def Cantidad(cantidad, id_prod)
    val = true
    if cantidad > 50
      val = false
    else
      producto =  Product.find(id_prod)
      if producto.stock.to_i < cantidad
        val = false
      end
    end
    return val
  end
end
