class AddConsentToUsers < ActiveRecord::Migration
  def change
    add_column :users, :consent, :boolean
    add_column :users, :consent_timestamp, :datetime
  end
end
