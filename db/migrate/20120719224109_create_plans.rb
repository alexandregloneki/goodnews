class CreatePlans < ActiveRecord::Migration
  def change
    create_table :plans do |t|
      t.string :name
      t.string :code
      t.float :value
      t.references :status

      t.timestamps
    end
    add_index :plans, :status_id
  end
end
