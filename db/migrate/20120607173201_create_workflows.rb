class CreateWorkflows < ActiveRecord::Migration
  def change
    create_table :workflows do |t|
      t.string :name
      t.references :status
      t.date :date_start
      t.date :date_finish
      t.references :account

      t.timestamps
    end
    add_index :workflows, :status_id
    add_index :workflows, :account_id
  end
end
