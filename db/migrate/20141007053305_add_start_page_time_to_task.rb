class AddStartPageTimeToTask < ActiveRecord::Migration
  def change
    add_column :tasks, :start_page_time, :Time
  end
end
