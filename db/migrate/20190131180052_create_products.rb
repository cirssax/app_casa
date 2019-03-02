class CreateProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :products do |t|
      t.string :nombre_producto, null: false, default: ""
      t.integer :marca, null: false
      t.integer :tipo,  null: false
      t.integer :stock,   null: false, default: 0
      t.string :ubicacion,  null: false, default: ""

      t.timestamps
    end
  end
end
