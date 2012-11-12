class SimbolTypeField < ActiveRecord::Migration
  def up
    add_column :type_fields, :simbol, :string
  end

  def down
    remove_column :type_fields, :simbol
  end
end
