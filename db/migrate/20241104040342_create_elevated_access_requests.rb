# db/migrate/20241104033905_create_elevated_access_requests.rb
class CreateElevatedAccessRequests < ActiveRecord::Migration[7.1]
  def change
    create_table :elevated_access_requests do |t|
      t.references :user, null: false, foreign_key: true
      t.references :access_point, null: false, foreign_key: true
      t.text :reason
      t.string :status, default: 'pending'  # Set default status to 'pending'

      t.timestamps
    end
  end
end