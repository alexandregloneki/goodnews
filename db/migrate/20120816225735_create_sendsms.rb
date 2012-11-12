class CreateSendsms < ActiveRecord::Migration
  def change
    create_table :sendsms do |t|
      t.references :sm
      t.references :workflow

      t.timestamps
    end
    add_index :sendsms, :sm_id
    add_index :sendsms, :workflow_id
  end
end
