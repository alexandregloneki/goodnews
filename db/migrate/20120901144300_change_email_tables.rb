class ChangeEmailTables < ActiveRecord::Migration
  def up
    remove_column :sendmails, :mail_id
    add_column :sendmails, :email_id, :integer
    drop_table :workflow_config_sends
    drop_table :mails
    
  end

  def down
  end
end
