class CreateConditions < ActiveRecord::Migration
  def change
    create_table :conditions do |t|

      t.timestamps
    end
  end
end
