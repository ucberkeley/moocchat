class AddEmailToUser < ActiveRecord::Migration
  def up
    add_column :users, :email, :string, :null => true, :default => nil
    add_index :users, :email
    Administrator.delete_all
    admins = {
      'Armando Fox' => 'armandofox@gmail.com',
      'Armando Fox (Berkeley)' => 'fox@berkeley.edu',
      'Bjoern Hartmann' => 'bjoern.hartmann@gmail.com',
      'Bjoern Hartmann (Berkeley)' => 'bjoern@berkeley.edu',
      'D Coetzee (Berkeley)' => 'dcoetzee@berkeley.edu',
      'D Coetzee' => 'dcoetzee@gmail.com',
      'Yeung John Li (Berkeley)' => 'liyeungjohn@berkeley.edu',
      'Marti Hearst (Berkeley)' => 'hearst@berkeley.edu',
      'Claire Thompson (Berkeley)' => 'cthompson44@berkeley.edu',
      'Claire Thompson' => 'clairethomp44@gmail.com'
    }
    admins.each_pair do |name,email|
      Administrator.create! :name => name, :email => email
    end
  end
  def down
    remove_column :users, :email
  end
end
