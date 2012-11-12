class ClearDdd < ActiveRecord::Migration
  def up
    remove_column :users, :ddd
  end

  def down
  end
end
