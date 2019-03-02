class FkUsersRequestsProducts < ActiveRecord::Migration[5.2]
  def change
    add_foreign_key :requests, :users, column: :usuario, primary_key: :id
    add_foreign_key :requests, :products, column: :producto, primary_key: :id
  end
end
