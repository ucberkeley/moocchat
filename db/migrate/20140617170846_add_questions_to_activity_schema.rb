class AddQuestionsToActivitySchema < ActiveRecord::Migration
  def change
    add_column :activity_schemas, :questions, :text
  end
end
