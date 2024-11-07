# frozen_string_literal: true

class AddDeviseToUsers < ActiveRecord::Migration[7.1]
  def self.up
    change_table :users do |t|
      ## Database authenticatable
      # Comment or remove these lines if they already exist
      # t.string :email,              null: false, default: ""
      # t.string :encrypted_password, null: false, default: ""

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      # Uncomment the lines you need
      # t.integer  :sign_in_count, default: 0, null: false
      # t.datetime :current_sign_in_at
      # t.datetime :last_sign_in_at
      # t.string   :current_sign_in_ip
      # t.string   :last_sign_in_ip

      ## Confirmable
      # t.string   :confirmation_token
      # t.datetime :confirmed_at
      # t.datetime :confirmation_sent_at
      # t.string   :unconfirmed_email # Only if using reconfirmable

      ## Lockable
      # t.integer  :failed_attempts, default: 0, null: false # Only if lock strategy is :failed_attempts
      # t.string   :unlock_token # Only if unlock strategy is :email or :both
      # t.datetime :locked_at

      # Uncomment below if timestamps were not included in your original model.
      # t.timestamps null: false
    end

    # Add indexes for email and reset_password_token only if the columns exist
    add_index :users, :email, unique: true if column_exists?(:users, :email)
    add_index :users, :reset_password_token, unique: true if column_exists?(:users, :reset_password_token)
    # add_index :users, :confirmation_token, unique: true if column_exists?(:users, :confirmation_token)
    # add_index :users, :unlock_token, unique: true if column_exists?(:users, :unlock_token)
  end

  def self.down
    # Specify the removal of fields only if they exist.
    change_table :users do |t|
      t.remove :reset_password_token if column_exists?(:users, :reset_password_token)
      t.remove :reset_password_sent_at if column_exists?(:users, :reset_password_sent_at)
      t.remove :remember_created_at if column_exists?(:users, :remember_created_at)
      # Remove other fields if needed
    end

    # Handle indexes
    remove_index :users, :email if index_exists?(:users, :email)
    remove_index :users, :reset_password_token if index_exists?(:users, :reset_password_token)
    # remove_index :users, :confirmation_token if index_exists?(:users, :confirmation_token)
    # remove_index :users, :unlock_token if index_exists?(:users, :unlock_token)
  end
end