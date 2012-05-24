class ChangeStatusIdField < ActiveRecord::Migration
  def self.up
		change_column :attendances, :status_id, :integer
		add_index :attendances, :status_id
  end

  def self.down
		remove_index :attendances, :status_id
		change_column :attendances, :status_id, :string
  end
end
