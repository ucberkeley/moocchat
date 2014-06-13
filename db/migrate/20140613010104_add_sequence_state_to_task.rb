class AddSequenceStateToTask < ActiveRecord::Migration
  def change
    remove_column :tasks, :current_question
    add_column :tasks, :sequence_state, :string, :null => true, :default => nil
  end
end
