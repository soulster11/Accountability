class CreateServices < ActiveRecord::Migration

  def self.up
    create_table :services do |t|
      t.timestamps
      t.timestamp :service
      t.text :description
    	t.integer :network_id
    end
  end

  def self.down
    drop_table :services
  end
	
end
