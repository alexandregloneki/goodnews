class AddSm < ActiveRecord::Migration
  def up
    remove_column :workflow_config_sends, :sms_id
    add_column :workflow_config_sends, :sm_id, :integer
  end

  def down
  end
end
