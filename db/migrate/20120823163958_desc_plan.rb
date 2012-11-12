class DescPlan < ActiveRecord::Migration
  def up
    add_column :plans, :description, :text
  end

  def down
  end
end
