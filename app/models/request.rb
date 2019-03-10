class Request < ApplicationRecord
  has_many :users
  has_many :products

  #Validaciones de cantidad
  validates :cantidad, presence: {message: "Debe asignar un stock"}, numericality: {only_integer: true, greater_than_or_equal_to: 0}, length: {in: 1..50, :message =>"Largo inadecuado"}

end
