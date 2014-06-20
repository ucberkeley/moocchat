class AddUserStateToTask < ActiveRecord::Migration
  def change
    change_table :tasks do |t|
      t.text :user_state
    end
  end
end
