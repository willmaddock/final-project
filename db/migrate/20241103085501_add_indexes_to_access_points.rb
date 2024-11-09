class AddIndexesToAccessPoints < ActiveRecord::Migration[7.1]
  def change
    # Adding indexes for performance
    add_index :access_points, :location
    add_index :access_points, :access_level
    add_index :access_points, :description

    # Uncomment the lines below to add unique indexes if applicable
    # add_index :access_points, :location, unique: true
    # add_index :access_points, :access_level, unique: true
    # add_index :access_points, :description, unique: true
  end
end
