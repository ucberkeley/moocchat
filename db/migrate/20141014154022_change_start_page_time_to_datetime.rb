class ChangeStartPageTimeToDatetime < ActiveRecord::Migration
  def up
    remove_column :tasks, :start_page_time
    add_column :tasks, :start_page_time, :datetime
  end

  def down
    remove_column :tasks, :start_page_time
    add_column :tasks, :start_page_time, :time
  end
end
