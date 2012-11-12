class AccountGeneration < ActiveRecord::Migration
   def self.up
    add_column :sms, :account_id, :integer
    add_column :emails, :account_id, :integer
  end
  
  def self.down
    remove_column :sms, :account_id
    remove_column :emails, :account_id
  end
end
