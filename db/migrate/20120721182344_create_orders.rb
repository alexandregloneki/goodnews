class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.references :account
      t.references :plan
      t.references :status
      t.text :observacao

      t.timestamps
    end
    add_index :orders, :account_id
    add_index :orders, :plan_id
    add_index :orders, :status_id
  end
end
