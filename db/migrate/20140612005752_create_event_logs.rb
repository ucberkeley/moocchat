class CreateEventLogs < ActiveRecord::Migration
  def change
    create_table :event_logs do |t|
      t.id :task_id
      t.text :value

      t.timestamps
    end
  end
end
