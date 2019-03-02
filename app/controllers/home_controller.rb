class HomeController < ApplicationController
  before_action :authenticate_user!

  def index
    @products = Product.all
    @requests = Request.all
    @users = User.all
    @products_low = Product.where("stock < 3")
  end

  def create

  end




  def show
    scraper = Scraper.new
    nombres = scraper.get_nombre
    markers = scraper.get_markers
    dates = scraper.get_date
    catalogos = scraper.get_catalogo

    @Lista_Ofertas = []

    (0..catalogos.size).each do |index|
      if index < catalogos.size
        nodo = Campo.new(markers[index], nombres[index] ,dates[index], catalogos[index]["data-link"])
        @Lista_Ofertas.push(nodo)
      end
    end
  end


  private

  class Scraper
    attr_accessor :parse_page2

    def initialize
      doc2 = HTTParty.get("https://www.tiendeo.cl/Folletos-Catalogos/supermercados")
      @parse_page2 ||= Nokogiri::HTML(doc2)
    end

    def get_markers
      item_container.css(".badgerow.badge-cat").css("a").children.map{|markers| markers.text}.compact
    end

    def get_nombre
      item_container.css(".column.first").css("h4").children.map { |nombres| nombres.text}.compact
    end

    def get_date
      item_container.css(".badges.visible-list").css("span.badgerow.badge-expiration").children.map { |date| date.text}.compact
    end

    def get_catalogo
      item_container.search("//a").css(".btn.btn-default.btn-transparent-red.hide-link.offer-url")
    end

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
      @supermercado = supermercado
      @nombre_oferta = nombre_oferta
      if fecha == "" || fecha == nil
        @fecha = -1
      else
        @fecha = fecha.scan(/\d/).join("").to_i
      end
      @enlace = "https://www.tiendeo.cl"+enlace
    end


  end


end
