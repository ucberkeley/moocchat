class AddHtmlToTemplate < ActiveRecord::Migration
  def change
    change_table :templates do |t|
      t.text :html, :null => true, :default => nil
    end
  end
end
