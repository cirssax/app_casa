class Type < ApplicationRecord
  has_many :products

  before_save :normalizacion

  VALID_NAME_REGEX = /(?=^.{2,50}$)[a-zA-ZñÑáéíóúÁÉÍÓÚ]+(\s[a-zA-ZñÑáéíóúÁÉÍÓÚ]+)?/
  #Validaciones del nombre
  validates :descrip_tipo, length: { in: 2..50 , :message => "Largo inadecuado de nombre de tipo"},  format: { with: VALID_NAME_REGEX , :message => "Formato invalido"},  presence: { message: "Debe llenar el campo" }


  def Repeticion
    if descrip_marca != nil
      @types = Type.select("descrip_tipo")
      @types.each do |type|
        if descrip_tipo.upcase == type.descrip_tipo
          errors.add(:descrip_tipo, "Esa tipo de producto ya existe")
        end
      end
    end
  end

  private
  def normalizacion
    self.descrip_tipo = descrip_tipo.upcase
  end
end
