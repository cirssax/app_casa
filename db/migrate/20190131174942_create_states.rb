class CreateStates < ActiveRecord::Migration[5.2]
  def change
    create_table :states do |t|
      t.string :descrip_estado,   null: false, default: ""

      t.timestamps
    end

    add_index :states, :descrip_estado,    unique: true
  end
end
