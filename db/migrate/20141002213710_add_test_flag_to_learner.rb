class AddTestFlagToLearner < ActiveRecord::Migration
  def change
    add_column :users, :for_testing, :boolean, :default => false
  end
end
