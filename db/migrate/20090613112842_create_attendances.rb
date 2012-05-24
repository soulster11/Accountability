class CreateAttendances < ActiveRecord::Migration

  def self.up

    create_table :attendances do |t|
      t.timestamps
      t.integer :service_id
      t.integer :person_id
      t.string :status_id
      t.boolean :contacted
      t.text :note
    end

		add_index :attendances, :service_id
		add_index :attendances, :person_id

    create_table :statuses do |t|
      t.string :designation
    end

  end

  def self.down
		drop_table :reasons
    drop_table :attendances
  end

end
