class CreatePeople < ActiveRecord::Migration

	def self.up

	create_table :people do |t|
		t.timestamps
		t.string :first_name
		t.string :last_name
		t.integer :type_id
		t.integer :parent_id
		t.integer :position
		t.integer :residence_id
		t.string :email_address
		t.string :cell_number
		t.boolean :active, :default => true
    t.string :picture_file_name
    t.string :picture_content_type
    t.integer :picture_file_size
    t.datetime :picture_updated_at
	end

    create_table :types do |t|
      t.string :designation
    end

  end

  def self.down
    drop_table :types
		drop_table :people
  end
	
end
