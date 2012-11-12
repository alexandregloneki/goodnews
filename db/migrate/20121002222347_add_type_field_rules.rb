class AddTypeFieldRules < ActiveRecord::Migration
  def up
     add_column :rules, :type_field_id, :integer
  end

  def down
  end
end
