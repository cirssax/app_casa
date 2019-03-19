class CreateStories < ActiveRecord::Migration[5.2]
  def change
    create_table :stories do |t|
      t.string :semana, null: false, default: ""
      t.integer :cantidad,  null: false, default: 0
      t.timestamps
    end
  end
end
