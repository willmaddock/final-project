class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :username, null: false
      t.string :full_name, null: false
      t.string :email, null: false
      t.string :encrypted_password, null: false  # Devise uses this for password storage
      t.integer :role, default: 0, null: false  # Assuming you're using an enum for roles
      t.integer :access_level
      t.datetime :last_login
      t.boolean :status, default: true  # Setting a default status, if necessary

      t.timestamps
    end

    add_index :users, :email, unique: true  # Ensure that emails are unique
  end
end