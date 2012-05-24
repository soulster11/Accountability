class CreateResidences < ActiveRecord::Migration

  def self.up
    create_table :residences do |t|
      t.timestamps
			t.string :address1
			t.string :address2
			t.string :city, :default => "Columbus"
			t.string :state, :default => "IN"
			t.string :zip, :default => "47201"
			t.string :phone_number
    end
  end

  def self.down
    drop_table :residences
  end
	
end
