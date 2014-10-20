class ChangeStartPageTimeToDatetime < ActiveRecord::Migration
  def up
    change_column :tasks, :start_page_time, :datetime
  end

  def down
    change_column :tasks, :start_page_time, :time
  end
end
