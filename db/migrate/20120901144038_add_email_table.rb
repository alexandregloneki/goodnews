class AddEmailTable < ActiveRecord::Migration
  def up
    create_table :emails do |t|
      t.string :title
      t.string :to
      t.string :cc
      t.string :cco
      t.references :status
      t.text :message
      t.references :workflow

      t.timestamps
    end
    add_index :emails, :status_id
    add_index :emails, :workflow_id
  
  end

  def down
    drop_table :emails
  end
end
