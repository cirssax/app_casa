class CreateBrands < ActiveRecord::Migration[5.2]
  def change
    create_table :brands do |t|
      t.string :descrip_marca,  null: false, default: ""

      t.timestamps
    end

    add_index :brands, :descrip_marca,    unique: true
  end
end
