class RemoveActivitySchemaidToTask < ActiveRecord::Migration
  def up
    remove_column :tasks, :activity_schema_id
  end

  def down
    add_column :tasks, :activity_schema_id, :integer
  end
end
