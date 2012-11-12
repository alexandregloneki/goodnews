class AddAccountEmail < ActiveRecord::Migration
  def up
    add_column :emails, :account_id, :integer
  end

  def down
  end
end
