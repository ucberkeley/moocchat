class AddActivitySchemaIdToActivitySchemas < ActiveRecord::Migration
  def change
    add_column :activity_schemas, :activity_schema_id, :integer
  end
end
