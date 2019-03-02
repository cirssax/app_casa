class CreateRequests < ActiveRecord::Migration[5.2]
  def change
    create_table :requests do |t|
      t.datetime :fecha,  null: false
      t.integer :cantidad,  null: false, default: 0
      t.integer :estado,  null: false
      t.integer :usuario,  null: false
      t.integer :producto,  null: false

      t.timestamps
    end
  end
end
