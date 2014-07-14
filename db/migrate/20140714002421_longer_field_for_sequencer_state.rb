class LongerFieldForSequencerState < ActiveRecord::Migration
  def up
    change_column :tasks, :sequence_state, :text
  end

  def down
    change_column :tasks, :sequence_state, :string
  end
end
