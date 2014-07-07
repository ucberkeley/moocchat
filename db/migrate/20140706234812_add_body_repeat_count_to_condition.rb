class AddBodyRepeatCountToCondition < ActiveRecord::Migration
  def change
    change_table :conditions do |t|
      t.integer :body_repeat_count
    end
  end
end
