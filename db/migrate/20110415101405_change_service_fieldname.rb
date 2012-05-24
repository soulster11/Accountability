class ChangeServiceFieldname < ActiveRecord::Migration
  def self.up
		rename_column :services, :service, :date_and_time
  end

  def self.down
		rename_column :services, :date_and_time, :service
  end
end
