class CreateGroups < ActiveRecord::Migration

  def self.up

    create_table :groups do |t|
      t.timestamps
			t.string :designation
      t.integer :leader_id
      t.integer :parent_id
      t.integer :position
			t.integer :network_id
    end

		create_table :memberships do |t|
      t.timestamps
      t.integer :person_id
      t.integer :group_id
    end

  end

  def self.down
		drop_table :memberships
    drop_table :groups
  end
	
end
