class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.references :workflow
      t.references :account

      t.timestamps
    end
    add_index :notifications, :workflow_id
    add_index :notifications, :account_id
  end
end
