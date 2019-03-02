class Brand < ApplicationRecord
  has_many :products

  before_save :normalizacion

  VALID_NAME_REGEX = /(?=^.{2,50}$)[a-zA-ZñÑáéíóúÁÉÍÓÚ]+(\s[a-zA-ZñÑáéíóúÁÉÍÓÚ]+)?/
  #Validaciones del nombre
  validates :descrip_marca, length: { in: 2..50 , :message => "Largo inadecuado de nombre de marca"},  format: { with: VALID_NAME_REGEX , :message => "Formato invalido"},  presence: { message: "Debe llenar el campo" }


  def Repeticion
    if descrip_marca != nil
      @brands = Brand.select("descrip_marca")
      @brands.each do |brand|
        if descrip_marca.upcase == brand.descrip_marca
          errors.add(:descrip_marca, "Esa marca ya existe")
        end
      end
    end
  end

  private
  def normalizacion
    self.descrip_marca = descrip_marca.upcase
  end

end
