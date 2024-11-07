class RenamePasswordHashToEncryptedPasswordInUsers < ActiveRecord::Migration[7.1]
  def change
    if column_exists?(:users, :password_hash)
      rename_column :users, :password_hash, :encrypted_password
    end
  end
end