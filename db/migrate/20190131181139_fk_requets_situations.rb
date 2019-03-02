class FkRequetsSituations < ActiveRecord::Migration[5.2]
  def change
    add_foreign_key :requests, :situations, column: :estado, primary_key: :id
  end
end
