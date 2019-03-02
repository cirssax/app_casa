class CreateSituations < ActiveRecord::Migration[5.2]
  def change
    create_table :situations do |t|
      t.string :descrip_estado_producto,   null: false, default: ""

      t.timestamps
    end

    add_index :situations, :descrip_estado_producto,    unique: true
  end
end
