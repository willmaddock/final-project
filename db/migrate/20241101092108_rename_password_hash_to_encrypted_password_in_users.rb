class RenamePasswordHashToEncryptedPasswordInUsers < ActiveRecord::Migration[7.1]
  def change
    rename_column :users, :password_hash, :encrypted_password
  end
end