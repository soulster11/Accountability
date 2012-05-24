class ChangeStandardTime < ActiveRecord::Migration
  def self.up
		change_column :schedules, :standard_time, :timestamp
  end

  def self.down
		change_column :schedules, :standard_time, :time
  end
end
