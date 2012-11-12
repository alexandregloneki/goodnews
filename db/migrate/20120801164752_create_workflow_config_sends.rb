class CreateWorkflowConfigSends < ActiveRecord::Migration
  def change
    create_table :workflow_config_sends do |t|
      t.references :workflow
      t.references :email
      t.references :sms
      t.references :account

      t.timestamps
    end
    add_index :workflow_config_sends, :workflow_id
    add_index :workflow_config_sends, :email_id
    add_index :workflow_config_sends, :sms_id
    add_index :workflow_config_sends, :account_id
  end
end
