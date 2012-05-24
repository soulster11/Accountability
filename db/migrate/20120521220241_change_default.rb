class ChangeDefault < ActiveRecord::Migration
  def up
		change_column_default(:attendances, :status_id, 8)
  end

  def down
		change_column_default(:attendances, :status_id, 1)
  end
end
