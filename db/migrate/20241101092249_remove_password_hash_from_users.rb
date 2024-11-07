class RemovePasswordHashFromUsers < ActiveRecord::Migration[7.1]
  def change
    remove_column :users, :password_hash, :string
  end
end
