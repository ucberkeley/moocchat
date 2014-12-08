class AddLastHeartbeatToTask < ActiveRecord::Migration
  def change
    add_column :tasks, :last_heartbeat, :datetime
  end
end
