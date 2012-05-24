class CreateUsers < ActiveRecord::Migration

  def self.up
    create_table :users do |t|
      t.timestamps
      t.string :username
      t.string :password
      t.integer :person_id
			t.boolean :administrator
			t.string :salt
    end
  end

  def self.down
    drop_table :users
  end
	
end
