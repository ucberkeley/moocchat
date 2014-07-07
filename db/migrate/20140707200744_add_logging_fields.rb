class AddLoggingFields < ActiveRecord::Migration
  FOREIGN_KEYS = %w(question task learner activity_schema condition)

  def up
    remove_column :event_logs, :tasks_id
    remove_column :event_logs, :updated_at # events are immutable
    change_table :event_logs do |t|
      t.string :name
      t.integer :counter
      t.integer :subcounter
      t.integer :question_counter
      t.string :chat_group
      FOREIGN_KEYS.each { |key| t.references key }
    end
    # foreign key indices
    FOREIGN_KEYS.each { |key| add_index :event_logs, "#{key}_id" }
  end

  def down
    change_table :event_logs do |t|
      t.integer :tasks_id
      t.datetime :updated_at
    end
    FOREIGN_KEYS.each { |key| remove_column :event_logs, "#{key}_id" }
    %w(name counter subcounter question_counter chat_group).each do |col|
      remove_column :event_logs, col
    end
  end
end
