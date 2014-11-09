class AddConditionIdToActivitySchema < ActiveRecord::Migration
  def change
    add_column :activity_schemas, :condition_id, :integer
  end
end
