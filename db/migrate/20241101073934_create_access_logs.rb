class CreateAccessLogs < ActiveRecord::Migration[7.1]
  def change
    create_table :access_logs do |t|
      t.references :user, null: false, foreign_key: true
      t.references :access_point, null: false, foreign_key: true
      t.datetime :timestamp, null: false  # Ensure this cannot be null
      t.boolean :successful, default: false  # Default value for successful

      t.timestamps
    end

    # Optional: Adding indexes for optimization
    add_index :access_logs, [:user_id, :timestamp]  # For querying logs by user
    add_index :access_logs, [:access_point_id, :timestamp]  # For querying logs by access point
  end
end