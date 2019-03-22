class HomeController < ApplicationController
  before_action :authenticate_user!

  def index
    @products = Product.all
    @requests = Request.order(created_at: :desc).where("estado = 1")
    @users = User.all
    @products_low = Product.where("stock < 3")
    @stories = Story.order(:updated_at)

    @cristobal = Request.where("usuario = 4 AND estado = 1") #cambiar id a 4
    @nury = Request.where("usuario = 3 AND estado = 1")
    @ricardo = Request.where("usuario = 2 AND estado = 1")

    #Eliminacion de los productos en consumo que llevan mas de dos días
    if Date.today.strftime("%A").downcase == 'sunday'
      i = 0
      fecha_actual = DateTime.now #captura fecha actual
      if fecha_actual.strftime("%H").to_i == 23 && fecha_actual.strftime("%M").to_i == 30 #cuando son las 23 hrs del domingo
        dia_domingo_actual = fecha_actual.strftime("%d").to_i #captura domingo actual
        mes_domingo_actual = fecha_actual.strftime("%m").to_i #captura del mes
        anio_domingo_actual = fecha_actual.strftime("%Y").to_i #captura año
        @request = Request.all
        @request.each do |request|
          if request.estado.to_i == 2 #Caso en que está eliminado
            if request.fecha.strftime("%Y").to_i <= anio_domingo_actual.to_i #comparacion de que el año sea menor o igual
              if request.fecha.strftime("%m").to_i <= mes_domingo_actual.to_i #comparacion de que el mes sea menor o igual
                if request.fecha.strftime("%d").to_i <= dia_domingo_actual.to_i #comparacion de que el dia sea menor o igual
                  i = i + 1
                  request.destroy
                end
              end
            end
          end
        end
        dia = dia_domingo_actual - 6
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
        semana = dia.to_s +"-"+ mes.to_s
        #Rotacion de registros semanales

        #Rotacion del registro 1 al 2 y perdida del 2
        @requests[2].update_attribute :semana, @requests[1].semana.to_s
        @requests[2].update_attribute :cantidad, @requests[1].cantidad.to_i

        #Rotacion del registro 0 al 1
        @requests[1].update_attribute :semana, @requests[0].semana.to_s
        @requests[1].update_attribute :cantidad, @requests[0].cantidad.to_i

        #Sobree escritura del registro 0 con los datos nuevos
        @requests[0].update_attribute :semana, semana.to_s
        @requests[0].update_attribute :cantidad, i.to_i
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
