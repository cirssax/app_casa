class CreateTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :types do |t|
      t.string :descrip_tipo, null: false, default: ""

      t.timestamps
    end

    add_index :types, :descrip_tipo,    unique: true
  end
end
