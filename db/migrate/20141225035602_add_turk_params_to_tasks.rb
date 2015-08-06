class AddTurkParamsToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :turk_params, :text
  end
end
