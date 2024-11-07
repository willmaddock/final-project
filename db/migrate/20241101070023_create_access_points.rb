class CreateAccessPoints < ActiveRecord::Migration[7.1]
  def change
    create_table :access_points do |t|
      t.string :location
      t.integer :access_level
      t.text :description
      t.boolean :status

      t.timestamps
    end
  end
end
