class CreateAccessLogs < ActiveRecord::Migration[7.1]
  def change
    create_table :access_logs do |t|
      t.references :user, null: false, foreign_key: true
      t.references :access_point, null: false, foreign_key: true
      t.datetime :timestamp
      t.boolean :successful

      t.timestamps
    end
  end
end
