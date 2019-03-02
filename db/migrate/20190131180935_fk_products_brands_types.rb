class FkProductsBrandsTypes < ActiveRecord::Migration[5.2]
  def change
    add_foreign_key :products, :brands, column: :marca, primary_key: :id
    add_foreign_key :products, :types, column: :tipo, primary_key: :id
  end
end
