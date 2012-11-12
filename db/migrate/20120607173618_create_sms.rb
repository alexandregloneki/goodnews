class CreateSms < ActiveRecord::Migration
  def change
    create_table :sms do |t|
      t.string :ddd
      t.string :number_dispatch
      t.string :name_sender
      t.string :phone_sender
      t.text :message
      t.references :workflow
      t.references :status
      t.timestamps
    end
    add_index :sms, :workflow_id
    add_index :sms, :status_id
  end
end
