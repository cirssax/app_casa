class Role < ApplicationRecord
  has_many :users

  before_save :normalizacion

  VALID_NAME_REGEX = /(?=^.{2,50}$)[a-zA-ZñÑáéíóúÁÉÍÓÚ]+(\s[a-zA-ZñÑáéíóúÁÉÍÓÚ]+)?/
  #Validaciones del nombre
  validates :descrip_rol, length: { in: 2..50 , :message => "Largo inadecuado de nombre de rol"},  format: { with: VALID_NAME_REGEX , :message => "Formato invalido"},  presence: { message: "Debe llenar el campo" }


  def Repeticion
    if descrip_rol != nil
      @roles = Role.select("descrip_rol")
      @roles.each do |rol|
        if descrip_rol.upcase == rol.descrip_rol
          errors.add(:descrip_rol, "Ese rol de usuario ya existe")
        end
      end
    end
  end

  private
  def normalizacion
    self.descrip_rol = descrip_rol.upcase
  end
end
