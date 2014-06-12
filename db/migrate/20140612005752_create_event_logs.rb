class CreateEventLogs < ActiveRecord::Migration
  def change
    create_table :event_logs do |t|
      t.belongs_to :task_id
      t.text :value
      t.timestamps
    end
  end
end
