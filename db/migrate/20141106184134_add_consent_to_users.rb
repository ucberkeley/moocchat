class AddConsentToUsers < ActiveRecord::Migration
  def change
    add_column :users, :consent, :boolean, :default => nil, :null => true
    add_column :users, :consent_timestamp, :datetime, :null => true
  end
end
