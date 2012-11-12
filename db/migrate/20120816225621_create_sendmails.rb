class CreateSendEmails < ActiveRecord::Migration
  def change
    create_table :sendmails do |t|
      t.references :email
      t.references :workflow

      t.timestamps
    end
    add_index :sendmails, :email_id
    add_index :sendmails, :workflow_id
  end
end
