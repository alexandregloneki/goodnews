class CreateSmsnotifications < ActiveRecord::Migration
  def change
    create_table :smsnotifications do |t|
      t.references :sm

      t.timestamps
    end
    add_index :smsnotifications, :sm_id
  end
end
