class AddIndexesToUsers < ActiveRecord::Migration[7.1]
  def change
    add_index :users, :username
    add_index :users, :role
  end
end