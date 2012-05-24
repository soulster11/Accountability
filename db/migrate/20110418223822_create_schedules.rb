class CreateSchedules < ActiveRecord::Migration
  def self.up
    create_table :schedules do |t|
      t.timestamps
			t.time :standard_time
			t.string :default_day
			t.integer :network_id
			t.string :description
    end
  end

  def self.down
    drop_table :schedules
  end
end
