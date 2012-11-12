class ChangeRules < ActiveRecord::Migration
  def up
    add_column :rules, :name, :string
  end

  def down
    remove_column :rules, :name
  end
end
