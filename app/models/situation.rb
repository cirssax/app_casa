class Situation < ApplicationRecord
  has_many :requests

  before_save :normalizacion

  VALID_NAME_REGEX = /(?=^.{2,50}$)[a-zA-ZñÑáéíóúÁÉÍÓÚ]+(\s[a-zA-ZñÑáéíóúÁÉÍÓÚ]+)?/
  #Validaciones del nombre
  validates :descrip_estado_producto, length: { in: 2..50 , :message => "Largo inadecuado de nombre de tipo"},  format: { with: VALID_NAME_REGEX , :message => "Formato invalido"},  presence: { message: "Debe llenar el campo" }


  def Repeticion
    if descrip_marca != nil
      @situations = Situation.select("descrip_estado_producto")
      @situations.each do |situation|
        if descrip_estado_producto.upcase == situation.descrip_estado_producto
          errors.add(:descrip_estado_producto, "Ese estado de consumo ya existe")
        end
      end
    end
  end

  private
  def normalizacion
    self.descrip_estado_producto = descrip_estado_producto.upcase
  end
end
