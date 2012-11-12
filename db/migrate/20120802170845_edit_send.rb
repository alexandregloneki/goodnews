class EditSend < ActiveRecord::Migration
  def self.up
    remove_column :workflow_config_sends, :email_id
    add_column :workflow_config_sends, :email_id, :integer
    
  end
  
  def self.down
    
  end
end
