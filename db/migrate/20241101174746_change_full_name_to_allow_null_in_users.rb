class ChangeFullNameToAllowNullInUsers < ActiveRecord::Migration[7.1]
  def change
    change_column_null :users, :full_name, true
  end
end