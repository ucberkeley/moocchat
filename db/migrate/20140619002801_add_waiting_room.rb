class AddWaitingRoom < ActiveRecord::Migration
  def up
    create_table :waiting_rooms, :force => true do |t|
      t.timestamps
      t.references :condition
      t.references :activity_schema
      t.datetime :expires_at
    end
    add_index :waiting_rooms, [:condition_id, :activity_schema_id], :unique => true
    change_table :tasks do |t|
      t.references :waiting_room
    end
    add_index :tasks, :waiting_room_id
  end

  def down
    drop_table :waiting_rooms
    remove_column :tasks, :waiting_room_id
  end
end
