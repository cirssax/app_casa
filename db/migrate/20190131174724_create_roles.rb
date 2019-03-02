class CreateRoles < ActiveRecord::Migration[5.2]
  def change
    create_table :roles do |t|
      t.string :descrip_rol, null: false, default: ""
      t.timestamps
    end

    add_index :roles, :descrip_rol,                unique: true
  end
end
