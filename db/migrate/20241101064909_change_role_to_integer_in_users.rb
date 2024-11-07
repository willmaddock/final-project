class ChangeRoleToIntegerInUsers < ActiveRecord::Migration[7.0]
  def change
    change_column :users, :role, :integer, default: 0, null: false
  end
end