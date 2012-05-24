class CreateNetworks < ActiveRecord::Migration
	def self.up
		create_table :networks do |t|
			t.timestamps
			t.string :designation
    end
	end
  
	def self.down
		drop_table :networks
	end
end
