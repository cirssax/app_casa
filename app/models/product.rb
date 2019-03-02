class Product < ApplicationRecord
  has_one :type
  has_one :brand

  scope :by_types, -> tipo {where(:type => tipo)}
  scope :by_brands, -> marca {where(:brand => marca)}

  before_save :normalizacion

  VALID_NAME_REGEX = /(?=^.{2,50}$)[a-zA-ZñÑáéíóúÁÉÍÓÚ]+(\s[a-zA-ZñÑáéíóúÁÉÍÓÚ]+)?/

  #Validaciones del tipo
  validates :tipo, presence: {messege: "Debe seleccionar un tipo de Producto"}
  #Validaciones del stock
  validates :marca, presence: {messege: "Debe seleccionar una marca"}
  #Validaciones del precio
  validates :stock, presence: {message: "Debe asignar un stock"}, numericality: {only_integer: true, greater_than_or_equal_to: 0}, length: {in: 1..10, :message =>"Largo inadecuado"}
  #Validaciones del nombre
  validates :nombre_producto, length: { in: 2..50 , :message => "Largo inadecuado de producto"},  format: { with: VALID_NAME_REGEX , :message => "Formato invalido"},  presence: { message: "Debe llenar el campo" }
  #Validaciones de la ubicacion
  validates :ubicacion, length: {in: 2..100, :message => "Largo inadecuado de la descripción para la ubicacion"}, presence: { message: "Debe colocar la ubicacion"}


  def Repeticion
    if nombre_producto != nil
      @productos = Product.select("nombre_producto")
      @productos.each do |producto|
        if nombre_producto.upcase == producto.nombre_producto
          errors.add(:nombre_producto, "Ese producto ya existe")
        end
      end
    end
  end

  private
  def normalizacion
    self.nombre_producto = nombre_producto.upcase
    self.ubicacion = ubicacion.upcase
  end
end
