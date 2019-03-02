class FkUsersRolesStates < ActiveRecord::Migration[5.2]
  def change
    add_foreign_key :users, :roles, column: :rol, primary_key: :id
    add_foreign_key :users, :states, column: :estado, primary_key: :id
  end
end
