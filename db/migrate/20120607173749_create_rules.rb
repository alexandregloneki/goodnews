class CreateRules < ActiveRecord::Migration
  def change
    create_table :rules do |t|
      t.string :field_references
      t.string :field_comparation
      t.string :value_comparation
      t.references :operator
      t.references :workflow

      t.timestamps
    end
    add_index :rules, :operator_id
    add_index :rules, :workflow_id
  end
end
