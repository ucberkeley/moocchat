class AddWaitingRoomAndTimingInfo < ActiveRecord::Migration
  def up
    # waiting room belongs to condition and activity schema
    create_table :waiting_rooms, :force => true do |t|
      t.timestamps
      t.references :condition
      t.references :activity_schema
      t.datetime :expires_at
    end
    add_index :waiting_rooms, [:condition_id, :activity_schema_id], :unique => true
    # waiting room has many tasks
    change_table :tasks do |t|
      t.references :waiting_room
    end
    add_index :tasks, :waiting_room_id
    add_index :tasks, :learner_id
    add_index :tasks, :condition_id
    add_index :tasks, :activity_schema_id
    remove_column :tasks, :tasks_id # bug in earlier migration

    # condition has min group size and max group size
    change_table :conditions do |t|
      t.integer :preferred_group_size
      t.integer :minimum_group_size
    end

    # activity schema knows start and end times and group formation frequency
    change_table :activity_schemas do |t|
      t.datetime :start_time
      t.datetime :end_time
      t.integer :starts_every
    end

  end

  def down
    drop_table :waiting_rooms
    remove_column :tasks, :waiting_room_id
  end
end
