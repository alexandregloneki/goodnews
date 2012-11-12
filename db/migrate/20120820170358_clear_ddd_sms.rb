class ClearDddSms < ActiveRecord::Migration
  def up
    remove_column :sms, :ddd
  end

  def down
  end
end
