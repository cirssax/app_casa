class HomeController < ApplicationController
  before_action :authenticate_user!

  def index
    @products = Product.all
    @requests = Request.where("estado = 1")
    @users = User.all
    @products_low = Product.where("stock < 3")

    #Eliminacion de los productos en consumo que llevan mas de dos días
    fecha_actual = DateTime.now
    dia_actual = fecha_actual.strftime("%d").to_i
    dia_actual = dia_actual - 7
    @request = Request.all
    @request.each do |request|
      if request.estado.to_i == 2 #Caso en que está eliminado
        if request.fecha.strftime("%d").to_i <= dia_actual.to_i
          hora_actual = fecha_actual.strftime("%H")
          if request.fecha.strftime("%H").to_i <= hora_actual.to_i
            request.destroy
          end
        end
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
      elsif id == 1
        scraper = Jumbo.new
      elsif id == 2
        scraper = Tottus.new
      elsif id == 3
        scraper = LiderExpress.new
      elsif id == 4
        scraper = Unimarc.new
      elsif id == 5
        scraper = SantaIsabel.new
      elsif id == 6
        scraper = Alvi.new
      elsif id == 7
        scraper = Mayorista.new
      else
        scraper = SuperAcuenta.new
      end

      nombres = scraper.get_nombre
      markers = scraper.get_markers
      dates = scraper.get_date
      catalogos = scraper.get_catalogo

      @ListaOferta = []

      (0..catalogos.size).each do |i|
        if i < catalogos.size
          #puts "https://www.tiendeo.cl"+catalogos[i]["data-link"].to_s
          nodo = Campo.new(markers[i], nombres[i], dates[i], catalogos[i]["data-link"])
          @ListaOferta.push(nodo)
        end
      end


    end
  end


  private
  #0
  class Lider
    attr_accessor :parse_page2

    def initialize
      doc2 = HTTParty.get("https://www.tiendeo.cl/santiago/lider")
      @parse_page2 ||= Nokogiri::HTML(doc2)
    end

    def get_markers
      item_container.css(".badgerow.badge-cat").css("span.hide-link-find").children.map{|markers| markers.text}.compact
    end

    def get_nombre
      item_container.css(".column.first").css("h4.item-heading.hide-link-find.catalog-item-heading").children.map { |nombres| nombres.text}.compact
    end

    def get_date
      item_container.css(".badges.visible-list").css("span.badgerow.badge-expiration").children.map { |date| date.text}.compact
    end

    def get_catalogo
      item_container.search("//a").css(".btn.btn-default.btn-transparent-red.hide-link.offer-url")
    end

    private

    def item_container
      parse_page2.css(".item.col-xs-6.col-sm-4.col-md-4.col-lg-3.col-xl-2.catalogo.list-group-item")
    end
  end

  #1
  class Jumbo
    attr_accessor :parse_page2

    def initialize
      doc2 = HTTParty.get("https://www.tiendeo.cl/santiago/jumbo")
      @parse_page2 ||= Nokogiri::HTML(doc2)
    end

    def get_markers
      item_container.css(".badgerow.badge-cat").css("span.hide-link-find").children.map{|markers| markers.text}.compact
    end

    def get_nombre
      item_container.css(".column.first").css("h4.item-heading.hide-link-find.catalog-item-heading").children.map { |nombres| nombres.text}.compact
    end

    def get_date
      item_container.css(".badges.visible-list").css("span.badgerow.badge-expiration").children.map { |date| date.text}.compact
    end

    def get_catalogo
      item_container.search("//a").css(".btn.btn-default.btn-transparent-red.hide-link.offer-url")
    end

    private

    def item_container
      parse_page2.css(".item.col-xs-6.col-sm-4.col-md-4.col-lg-3.col-xl-2.catalogo.list-group-item")
    end
  end

  #2
  class Tottus
    attr_accessor :parse_page2

    def initialize
      doc2 = HTTParty.get("https://www.tiendeo.cl/santiago/tottus")
      @parse_page2 ||= Nokogiri::HTML(doc2)
    end

    def get_markers
      item_container.css(".badgerow.badge-cat").css("span.hide-link-find").children.map{|markers| markers.text}.compact
    end

    def get_nombre
      item_container.css(".column.first").css("h4.item-heading.hide-link-find.catalog-item-heading").children.map { |nombres| nombres.text}.compact
    end

    def get_date
      item_container.css(".badges.visible-list").css("span.badgerow.badge-expiration").children.map { |date| date.text}.compact
    end

    def get_catalogo
      item_container.search("//a").css(".btn.btn-default.btn-transparent-red.hide-link.offer-url")
    end

    private

    def item_container
      parse_page2.css(".item.col-xs-6.col-sm-4.col-md-4.col-lg-3.col-xl-2.catalogo.list-group-item")
    end
  end

  #3
  class LiderExpress
    attr_accessor :parse_page2

    def initialize
      doc2 = HTTParty.get("https://www.tiendeo.cl/santiago/lider-express")
      @parse_page2 ||= Nokogiri::HTML(doc2)
    end

    def get_markers
      item_container.css(".badgerow.badge-cat").css("span.hide-link-find").children.map{|markers| markers.text}.compact
    end

    def get_nombre
      item_container.css(".column.first").css("h4.item-heading.hide-link-find.catalog-item-heading").children.map { |nombres| nombres.text}.compact
    end

    def get_date
      item_container.css(".badges.visible-list").css("span.badgerow.badge-expiration").children.map { |date| date.text}.compact
    end

    def get_catalogo
      item_container.search("//a").css(".btn.btn-default.btn-transparent-red.hide-link.offer-url")
    end

    private

    def item_container
      parse_page2.css(".item.col-xs-6.col-sm-4.col-md-4.col-lg-3.col-xl-2.catalogo.list-group-item")
    end
  end

  #4
  class Unimarc
    attr_accessor :parse_page2

    def initialize
      doc2 = HTTParty.get("https://www.tiendeo.cl/santiago/unimarc")
      @parse_page2 ||= Nokogiri::HTML(doc2)
    end

    def get_markers
      item_container.css(".badgerow.badge-cat").css("span.hide-link-find").children.map{|markers| markers.text}.compact
    end

    def get_nombre
      item_container.css(".column.first").css("h4.item-heading.hide-link-find.catalog-item-heading").children.map { |nombres| nombres.text}.compact
    end

    def get_date
      item_container.css(".badges.visible-list").css("span.badgerow.badge-expiration").children.map { |date| date.text}.compact
    end

    def get_catalogo
      item_container.search("//a").css(".btn.btn-default.btn-transparent-red.hide-link.offer-url")
    end

    private

    def item_container
      parse_page2.css(".item.col-xs-6.col-sm-4.col-md-4.col-lg-3.col-xl-2.catalogo.list-group-item")
    end
  end

  #5
  class SantaIsabel
    attr_accessor :parse_page2

    def initialize
      doc2 = HTTParty.get("https://www.tiendeo.cl/santiago/santa-isabel")
      @parse_page2 ||= Nokogiri::HTML(doc2)
    end

    def get_markers
      item_container.css(".badgerow.badge-cat").css("span.hide-link-find").children.map{|markers| markers.text}.compact
    end

    def get_nombre
      item_container.css(".column.first").css("h4.item-heading.hide-link-find.catalog-item-heading").children.map { |nombres| nombres.text}.compact
    end

    def get_date
      item_container.css(".badges.visible-list").css("span.badgerow.badge-expiration").children.map { |date| date.text}.compact
    end

    def get_catalogo
      item_container.search("//a").css(".btn.btn-default.btn-transparent-red.hide-link.offer-url")
    end

    private

    def item_container
      parse_page2.css(".item.col-xs-6.col-sm-4.col-md-4.col-lg-3.col-xl-2.catalogo.list-group-item")
    end
  end

  #6
  class Alvi
    attr_accessor :parse_page2

    def initialize
      doc2 = HTTParty.get("https://www.tiendeo.cl/santiago/alvi")
      @parse_page2 ||= Nokogiri::HTML(doc2)
    end

    def get_markers
      item_container.css(".badgerow.badge-cat").css("span.hide-link-find").children.map{|markers| markers.text}.compact
    end

    def get_nombre
      item_container.css(".column.first").css("h4.item-heading.hide-link-find.catalog-item-heading").children.map { |nombres| nombres.text}.compact
    end

    def get_date
      item_container.css(".badges.visible-list").css("span.badgerow.badge-expiration").children.map { |date| date.text}.compact
    end

    def get_catalogo
      item_container.search("//a").css(".btn.btn-default.btn-transparent-red.hide-link.offer-url")
    end

    private

    def item_container
      parse_page2.css(".item.col-xs-6.col-sm-4.col-md-4.col-lg-3.col-xl-2.catalogo.list-group-item")
    end
  end

  #7
  class Mayorista
    attr_accessor :parse_page2

    def initialize
      doc2 = HTTParty.get("https://www.tiendeo.cl/santiago/mayorista-10")
      @parse_page2 ||= Nokogiri::HTML(doc2)
    end

    def get_markers
      item_container.css(".badgerow.badge-cat").css("span.hide-link-find").children.map{|markers| markers.text}.compact
    end

    def get_nombre
      item_container.css(".column.first").css("h4.item-heading.hide-link-find.catalog-item-heading").children.map { |nombres| nombres.text}.compact
    end

    def get_date
      item_container.css(".badges.visible-list").css("span.badgerow.badge-expiration").children.map { |date| date.text}.compact
    end

    def get_catalogo
      item_container.search("//a").css(".btn.btn-default.btn-transparent-red.hide-link.offer-url")
    end

    private

    def item_container
      parse_page2.css(".item.col-xs-6.col-sm-4.col-md-4.col-lg-3.col-xl-2.catalogo.list-group-item")
    end
  end

  #8
  class SuperAcuenta
    attr_accessor :parse_page2

    def initialize
      doc2 = HTTParty.get("https://www.tiendeo.cl/santiago/super-bodega-acuenta")
      @parse_page2 ||= Nokogiri::HTML(doc2)
    end

    def get_markers
      item_container.css(".badgerow.badge-cat").css("span.hide-link-find").children.map{|markers| markers.text}.compact
    end

    def get_nombre
      item_container.css(".column.first").css("h4.item-heading.hide-link-find.catalog-item-heading").children.map { |nombres| nombres.text}.compact
    end

    def get_date
      item_container.css(".badges.visible-list").css("span.badgerow.badge-expiration").children.map { |date| date.text}.compact
    end

    def get_catalogo
      item_container.search("//a").css(".btn.btn-default.btn-transparent-red.hide-link.offer-url")
    end

    private

    def item_container
      parse_page2.css(".item.col-xs-6.col-sm-4.col-md-4.col-lg-3.col-xl-2.catalogo.list-group-item")
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
end
