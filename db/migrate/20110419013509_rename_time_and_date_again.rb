class RenameTimeAndDateAgain < ActiveRecord::Migration
  def self.up
		rename_column :services, :date_and_time, :dateandtime
  end

  def self.down
		rename_column :services, :dateandtime, :date_and_time
  end
end
