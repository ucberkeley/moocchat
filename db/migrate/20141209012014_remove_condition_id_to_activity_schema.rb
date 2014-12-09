class RemoveConditionIdToActivitySchema < ActiveRecord::Migration
  def up
    remove_column :activity_schemas, :condition_id
  end

  def down
    add_column :activity_schemas, :condition_id, :integer
  end
end
