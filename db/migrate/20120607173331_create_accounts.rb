class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.references :customer
      t.references :status

      t.timestamps
    end
    add_index :accounts, :customer_id
    add_index :accounts, :status_id
  end
end
