class RemovePasswordHashFromUsers < ActiveRecord::Migration[7.1]
  def change
    remove_column :users, :password_hash, :string, if_exists: true
  end
end