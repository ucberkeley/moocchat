class ChangeConditionPageAttributeNames < ActiveRecord::Migration
  def up
    rename_column :conditions, :prologue, :prologue_pages
    rename_column :conditions, :body, :body_pages
    rename_column :conditions, :epilogue, :epilogue_pages
  end

  def down
    rename_column :conditions, :prologue_pages, :prologue
    rename_column :conditions, :body_pages, :body
    rename_column :conditions, :epilogue_pages, :epilogue
  end
end
