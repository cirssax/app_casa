class State < ApplicationRecord
  has_many :users

  before_save :normalizacion

  VALID_NAME_REGEX = /(?=^.{2,50}$)[a-zA-ZñÑáéíóúÁÉÍÓÚ]+(\s[a-zA-ZñÑáéíóúÁÉÍÓÚ]+)?/
  #Validaciones del nombre
  validates :descrip_estado, length: { in: 2..50 , :message => "Largo inadecuado de nombre de estado"},  format: { with: VALID_NAME_REGEX , :message => "Formato invalido"},  presence: { message: "Debe llenar el campo" }


  def Repeticion
    if descrip_estado != nil
      @states = State.select("descrip_estado")
      @states.each do |state|
        if descrip_estado.upcase == state.descrip_estado
          errors.add(:descrip_estado, "Ese tipo estado de usuario ya existe")
        end
      end
    end
  end

  private
  def normalizacion
    self.descrip_estado = descrip_estado.upcase
  end

end
