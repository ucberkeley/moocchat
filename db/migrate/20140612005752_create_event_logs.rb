class CreateEventLogs < ActiveRecord::Migration
  def change
    create_table :event_logs do |t|
      t.references :tasks
      t.text :value
      t.timestamps
    end
  end
end
