class AddPrimaryActivitySchemaidToCondition < ActiveRecord::Migration
  def change
    add_column :conditions, :primary_activity_schema_id, :integer
    add_column :conditions, :time_filler_id, :integer
  end
end
