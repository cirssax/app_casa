class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one :role
  has_one :state
  has_many :requests

  VALID_NAME_REGEX = /(?=^.{2,50}$)[a-zA-ZñÑáéíóúÁÉÍÓÚ]+(\s[a-zA-ZñÑáéíóúÁÉÍÓÚ]+)?/
  VALID_CORREO_REGEX = /\A\S+@.+\.\S+\z/
  #attr_accessor :rut
  #Validaciones para el rut

  validates :nombre_usuario, length: { in: 2..50 , :message => "Largo inadecuado de nombre"},  format: { with: VALID_NAME_REGEX , :message => "Formato invalido"}
  #Validaciones para el apellido
  validates :apellidos_usuario, length: { in: 2..50 , :message => "Largo inadecuado de nombre"}, format: { with: VALID_NAME_REGEX , :message => "Formato invalido"}, presence: { message: "Debe llenar el campo" }
  #Validaciones para el estado
  validates :estado, presence: {message: "Debe seleccionar un estado"}
  #Validaciones para el rol
  validates :rol, presence: {message: "Debe seleccionar un rol"}
  #Validacion del correo
  validates :email, format:  {with: VALID_CORREO_REGEX, :message => "Formato invalido de correo"}, uniqueness: {message: "Ya existe un usuario asignado a ese correo"}
  #Validacion del login
  validates :login, length: { in: 2..50 , :message => "Largo inadecuado de login"},  format: { with: VALID_NAME_REGEX , :message => "Formato invalido"}, uniqueness: {message: "Ya existe un usuario a ese correo login"}

  before_save :normalizacion

  private
  def normalizacion
    self.nombre_usuario = nombre_usuario.upcase
    self.apellidos_usuario = apellidos_usuario.upcase
    self.email = email.downcase
    self.login = login.upcase
  end

end
