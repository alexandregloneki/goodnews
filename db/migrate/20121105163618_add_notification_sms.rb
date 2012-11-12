class AddNotificationSms < ActiveRecord::Migration
  def up
    add_column :smsnotifications, :notification_id, :integer
  end

  def down
  end
end
