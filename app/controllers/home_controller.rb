class HomeController < ApplicationController
  before_action :authenticate_user!

  def index
    @products = Product.all
    @requests = Request.order(created_at: :desc).where("estado = 1")
    @users = User.all
    @products_low = Product.where("stock < 3")
    @stories = Story.order(:id)

    #Productos consumidos por usuario: Cristobal
    @request1 = Request.where("usuario = 4 AND estado = 1") #cambiar id a 4
    i=0
    @request1.each do |request|
      i = i + request.cantidad.to_i
    end
    @cristobal = i
    i=0
    #Productos consumidos por usuario: Nury
    @request1 = Request.where("usuario = 3 AND estado = 1")
    @request1.each do |request|
      i = i + request.cantidad.to_i
    end
    @nury = i
    i=0

    #Productos consumidos por usuario: Ricardo
    @request1 = Request.where("usuario = 2 AND estado = 1")
    @request1.each do |request|
      i = i + request.cantidad.to_i
    end
    @ricardo = i

    #Eliminacion de los productos en consumo que llevan mas de dos días
    if Date.today.strftime("%A").downcase == 'sunday'
      fecha_actual = DateTime.now #captura fecha actual
      dia_domingo_actual = fecha_actual.strftime("%d").to_i #captura domingo actual
      mes_domingo_actual = fecha_actual.strftime("%m").to_i #captura del mes
      anio_domingo_actual = fecha_actual.strftime("%Y").to_i #captura año
      #Valor de registro semana
      dia = dia_domingo_actual - 7
      if dia > 0 #caso en que el dia domingo es mayor fecha mayor a 6 y no cambia el mes
        mes = mes_domingo_actual
      else #caso en que el lunes anterior era de un mes diferente
        mes = mes_domingo_actual.to_i - 1
        if mes == 1 || mes == 3 || mes == 5 || mes == 7 || mes == 8 || mes == 10 || mes == 12 #meses de 31 dias
          dia = 31 - dia.to_i
        elsif mes == 4 || mes == 6 || mes == 9 || mes == 11 #meses de 30 dias
          dia = 30 - dia.to_i
        else #febrero
          dia = 28 - dia.to_i
        end
      end

      #Obtencion del valor del registro 'semana'
      semana = "sem "+dia.to_s+"-"+ mes.to_s
      semana = semana.to_s
      #Obtencion del valor del último registro 'semana'
      registro = @stories[0].semana
      registro = registro.to_s
      registro = registro.downcase
      if semana.downcase != registro

        i = 0
        @request = Request.all
        @request.each do |request|
          if request.estado.to_i == 2 #Caso en que está eliminado
            #if request.fecha.strftime("%Y").to_i <= anio_domingo_actual.to_i #comparacion de que el año sea menor o igual
             # if request.fecha.strftime("%m").to_i <= mes_domingo_actual.to_i #comparacion de que el mes sea menor o igual
                #if request.fecha.strftime("%d").to_i <= dia_domingo_actual.to_i #comparacion de que el dia sea menor o igual
                  i = i + 1
                  request.destroy
                #end
              #end
           # end
          end
        end
        #Rotacion de registros semanales

        #Rotacion del registro 1 al 2 y perdida del 2
        @stories[2].update_attribute :semana, @stories[1].semana.to_s
        @stories[2].update_attribute :cantidad, @stories[1].cantidad.to_i

        #Rotacion del registro 0 al 1
        @stories[1].update_attribute :semana, @stories[0].semana.to_s
        @stories[1].update_attribute :cantidad, @stories[0].cantidad.to_i

        #Sobree escritura del registro 0 con los datos nuevos
        @stories[0].update_attribute :semana, semana.to_s
        @stories[0].update_attribute :cantidad, i.to_i

      end
    end
  end

  def show
    @supermercados = []

    nodo = SuperMercado.new("Lider", 0)
    @supermercados.push(nodo)

    nodo = SuperMercado.new("Jumbo", 1)
    @supermercados.push(nodo)

    nodo = SuperMercado.new("Tottus", 2)
    @supermercados.push(nodo)

    nodo = SuperMercado.new("Lider Express", 3)
    @supermercados.push(nodo)

    nodo = SuperMercado.new("Unimarc", 4)
    @supermercados.push(nodo)

    nodo = SuperMercado.new("Santa Isabel", 5)
    @supermercados.push(nodo)

    nodo = SuperMercado.new("Alvi", 6)
    @supermercados.push(nodo)

    nodo = SuperMercado.new("Mayorista 10", 7)
    @supermercados.push(nodo)

    nodo = SuperMercado.new("Super Bodega Acuenta", 8)
    @supermercados.push(nodo)

  end

  def supermercado
    respond_to do |format|
      #Caso en que se tiene que desactivar el usuario
      format.html {redirect_to home_path, notice: "Catalogos localizados"}
      format.json {render :show, status: :created}
      format.js
      id = params[:id]
      id = id.to_i

      if id == 0
        scraper = Lider.new
        markers = "Lider"
      elsif id == 1
        scraper = Jumbo.new
        markers = "Jumbo"
      elsif id == 2
        scraper = Tottus.new
        markers = "Tottus"
      elsif id == 3
        scraper = LiderExpress.new
        markers = "Lider Express"
      elsif id == 4
        scraper = Unimarc.new
        markers = "Unimarc"
      elsif id == 5
        scraper = SantaIsabel.new
        markers = "Santa Isabel"
      elsif id == 6
        scraper = Alvi.new
        markers = "Alvi"
      elsif id == 7
        scraper = Mayorista.new
        markers = "Mayorista 10"
      else
        scraper = SuperAcuenta.new
        markers = "Super Bodega Acuenta"
      end

      nombres = scraper.get_nombre
      dates = scraper.get_date
      catalogos = scraper.get_catalogo

      puts "\n"
      puts catalogos.size
      puts "\n"

      @ListaOferta = []

      (0..catalogos.size).each do |i|
        if i < catalogos.size
          nodo = Campo.new(markers, nombres[i], dates[i], catalogos[i]["data-link"])
          @ListaOferta.push(nodo)
        end
      end
    end
  end

  def low
    @products_low = LowProducts()
  end

  private
  def LowProducts
    @Lista = []
    @products = Product.order(:stock).where("stock < 3")
    @products.each do |product|
      nodo = LowStock.new(product.nombre_producto, product.stock, product.id)
      @Lista.push(nodo)
    end
    return @Lista
  end

  #0
  class Lider
    attr_accessor :parse_page2

    def initialize
      doc2 = HTTParty.get("https://www.tiendeo.cl/santiago/lider")
      @parse_page2 ||= Nokogiri::HTML(doc2)
    end

    def get_nombre
      item_container.css(".c·catalog__description.hide-link-find").css("h3.c·catalog__title.typo-head-16-med").children.map {|nombres| nombres.text}.compact
    end

    def get_date
      #item_container.css(".badges.visible-list").css("span.badgerow.badge-expiration").children.map { |date| date.text}.compact
      item_container.css(".c·catalog__stats.hide-link-find").css("p.o·daysleft.typo-caption-12-reg").children.map { |date| date.text}.compact
    end

    def get_catalogo
      item_container.search("//a").css(".c·catalog__button-open-product.o·button-arrow")
    end

    private

    def item_container
      parse_page2.css(".c·catalog.item.catalogo.js-print-item")
    end
  end

  #1
  class Jumbo
    attr_accessor :parse_page2

    def initialize
      doc2 = HTTParty.get("https://www.tiendeo.cl/santiago/jumbo")
      @parse_page2 ||= Nokogiri::HTML(doc2)
    end

    def get_nombre
      item_container.css(".c·catalog__description.hide-link-find").css("h3.c·catalog__title.typo-head-16-med").children.map {|nombres| nombres.text}.compact
    end

    def get_date
      #item_container.css(".badges.visible-list").css("span.badgerow.badge-expiration").children.map { |date| date.text}.compact
      item_container.css(".c·catalog__stats.hide-link-find").css("p.o·daysleft.typo-caption-12-reg").children.map { |date| date.text}.compact
    end

    def get_catalogo
      item_container.search("//a").css(".c·catalog__button-open-product.o·button-arrow")
    end

    private

    def item_container
      parse_page2.css(".c·catalog.item.catalogo.js-print-item")
    end

  end

  #2
  class Tottus
    attr_accessor :parse_page2

    def initialize
      doc2 = HTTParty.get("https://www.tiendeo.cl/santiago/tottus")
      @parse_page2 ||= Nokogiri::HTML(doc2)
    end

    def get_nombre
      item_container.css(".c·catalog__description.hide-link-find").css("h3.c·catalog__title.typo-head-16-med").children.map {|nombres| nombres.text}.compact
    end

    def get_date
      #item_container.css(".badges.visible-list").css("span.badgerow.badge-expiration").children.map { |date| date.text}.compact
      item_container.css(".c·catalog__stats.hide-link-find").css("p.o·daysleft.typo-caption-12-reg").children.map { |date| date.text}.compact
    end

    def get_catalogo
      item_container.search("//a").css(".c·catalog__button-open-product.o·button-arrow")
    end

    private

    def item_container
      parse_page2.css(".c·catalog.item.catalogo.js-print-item")
    end

  end

  #3
  class LiderExpress
    attr_accessor :parse_page2

    def initialize
      doc2 = HTTParty.get("https://www.tiendeo.cl/santiago/lider-express")
      @parse_page2 ||= Nokogiri::HTML(doc2)
    end

    def get_nombre
      item_container.css(".c·catalog__description.hide-link-find").css("h3.c·catalog__title.typo-head-16-med").children.map {|nombres| nombres.text}.compact
    end

    def get_date
      #item_container.css(".badges.visible-list").css("span.badgerow.badge-expiration").children.map { |date| date.text}.compact
      item_container.css(".c·catalog__stats.hide-link-find").css("p.o·daysleft.typo-caption-12-reg").children.map { |date| date.text}.compact
    end

    def get_catalogo
      item_container.search("//a").css(".c·catalog__button-open-product.o·button-arrow")
    end

    private

    def item_container
      parse_page2.css(".c·catalog.item.catalogo.js-print-item")
    end

  end

  #4
  class Unimarc
    attr_accessor :parse_page2

    def initialize
      doc2 = HTTParty.get("https://www.tiendeo.cl/santiago/unimarc")
      @parse_page2 ||= Nokogiri::HTML(doc2)
    end

    def get_nombre
      item_container.css(".c·catalog__description.hide-link-find").css("h3.c·catalog__title.typo-head-16-med").children.map {|nombres| nombres.text}.compact
    end

    def get_date
      #item_container.css(".badges.visible-list").css("span.badgerow.badge-expiration").children.map { |date| date.text}.compact
      item_container.css(".c·catalog__stats.hide-link-find").css("p.o·daysleft.typo-caption-12-reg").children.map { |date| date.text}.compact
    end

    def get_catalogo
      item_container.search("//a").css(".c·catalog__button-open-product.o·button-arrow")
    end

    private

    def item_container
      parse_page2.css(".c·catalog.item.catalogo.js-print-item")
    end

  end

  #5
  class SantaIsabel
    attr_accessor :parse_page2

    def initialize
      doc2 = HTTParty.get("https://www.tiendeo.cl/santiago/santa-isabel")
      @parse_page2 ||= Nokogiri::HTML(doc2)
    end

    def get_nombre
      item_container.css(".c·catalog__description.hide-link-find").css("h3.c·catalog__title.typo-head-16-med").children.map {|nombres| nombres.text}.compact
    end

    def get_date
      #item_container.css(".badges.visible-list").css("span.badgerow.badge-expiration").children.map { |date| date.text}.compact
      item_container.css(".c·catalog__stats.hide-link-find").css("p.o·daysleft.typo-caption-12-reg").children.map { |date| date.text}.compact
    end

    def get_catalogo
      item_container.search("//a").css(".c·catalog__button-open-product.o·button-arrow")
    end

    private

    def item_container
      parse_page2.css(".c·catalog.item.catalogo.js-print-item")
    end

  end

  #6
  class Alvi
    attr_accessor :parse_page2

    def initialize
      doc2 = HTTParty.get("https://www.tiendeo.cl/santiago/alvi")
      @parse_page2 ||= Nokogiri::HTML(doc2)
    end

    def get_nombre
      item_container.css(".c·catalog__description.hide-link-find").css("h3.c·catalog__title.typo-head-16-med").children.map {|nombres| nombres.text}.compact
    end

    def get_date
      #item_container.css(".badges.visible-list").css("span.badgerow.badge-expiration").children.map { |date| date.text}.compact
      item_container.css(".c·catalog__stats.hide-link-find").css("p.o·daysleft.typo-caption-12-reg").children.map { |date| date.text}.compact
    end

    def get_catalogo
      item_container.search("//a").css(".c·catalog__button-open-product.o·button-arrow")
    end

    private

    def item_container
      parse_page2.css(".c·catalog.item.catalogo.js-print-item")
    end

  end

  #7
  class Mayorista
    attr_accessor :parse_page2

    def initialize
      doc2 = HTTParty.get("https://www.tiendeo.cl/santiago/mayorista-10")
      @parse_page2 ||= Nokogiri::HTML(doc2)
    end

    def get_nombre
      item_container.css(".c·catalog__description.hide-link-find").css("h3.c·catalog__title.typo-head-16-med").children.map {|nombres| nombres.text}.compact
    end

    def get_date
      #item_container.css(".badges.visible-list").css("span.badgerow.badge-expiration").children.map { |date| date.text}.compact
      item_container.css(".c·catalog__stats.hide-link-find").css("p.o·daysleft.typo-caption-12-reg").children.map { |date| date.text}.compact
    end

    def get_catalogo
      item_container.search("//a").css(".c·catalog__button-open-product.o·button-arrow")
    end

    private

    def item_container
      parse_page2.css(".c·catalog.item.catalogo.js-print-item")
    end

  end

  #8
  class SuperAcuenta
    attr_accessor :parse_page2

    def initialize
      doc2 = HTTParty.get("https://www.tiendeo.cl/santiago/super-bodega-acuenta")
      @parse_page2 ||= Nokogiri::HTML(doc2)
    end

    def get_nombre
      item_container.css(".c·catalog__description.hide-link-find").css("h3.c·catalog__title.typo-head-16-med").children.map {|nombres| nombres.text}.compact
    end

    def get_date
      #item_container.css(".badges.visible-list").css("span.badgerow.badge-expiration").children.map { |date| date.text}.compact
      item_container.css(".c·catalog__stats.hide-link-find").css("p.o·daysleft.typo-caption-12-reg").children.map { |date| date.text}.compact
    end

    def get_catalogo
      item_container.search("//a").css(".c·catalog__button-open-product.o·button-arrow")
    end

    private

    def item_container
      parse_page2.css(".c·catalog.item.catalogo.js-print-item")
    end

  end


  class Campo
    attr_accessor :supermercado
    attr_accessor :nombre_oferta
    attr_accessor :fecha
    attr_accessor :enlace

    def initialize(supermercado, nombre_oferta ,fecha, enlace)
      if nombre_oferta != nil || nombre_oferta.to_s.strip != ""
        @nombre_oferta = nombre_oferta

        if supermercado != nil || supermercado.to_s.strip != ""
          @supermercado = supermercado

          if fecha.to_s.strip == "" || fecha == nil
            @fecha = -1

            if enlace != nil || enlace.to_s.strip != ""
              @enlace = "https://www.tiendeo.cl"+enlace
            end

          else
            @fecha = fecha.scan(/\d/).join("").to_i
            if enlace != nil || enlace.to_s.strip != ""
              @enlace = "https://www.tiendeo.cl"+enlace
            end
          end
        end
      end
    end
  end

  class SuperMercado
    attr_accessor :supermercados
    attr_accessor :id

    def initialize(supermercado, id)
      @supermercados = supermercado
      @id = id
    end
  end

  class LowStock
    attr_accessor :nombre_producto
    attr_accessor :stock
    def initialize(nombre, cantidad, id)
      @nombre_producto = nombre.titleize
      @consumo = Request.where("producto = ? AND estado = 1", id)
      if @consumo.size == 0
        @stock = cantidad.to_s
      else
        @stock = cantidad.to_s+"  (hay "+@consumo[0].cantidad.to_s+" en consumo)"
      end

    end
  end
end
