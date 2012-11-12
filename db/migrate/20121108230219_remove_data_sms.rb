class RemoveDataSms < ActiveRecord::Migration
  def up
    remove_column :sms, :phone_sender
    remove_column :sms, :workflow_id
  end

  def down
  end
end
