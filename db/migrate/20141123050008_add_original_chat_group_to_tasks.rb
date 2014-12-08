class AddOriginalChatGroupToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :original_chat_group, :string
  end
end
