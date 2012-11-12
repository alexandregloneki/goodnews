class AddNotificationEmail < ActiveRecord::Migration
  def up
    add_column :emailnotifications, :notification_id, :integer
  end

  def down
  end
end
