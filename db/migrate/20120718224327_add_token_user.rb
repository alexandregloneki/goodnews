class AddTokenUser < ActiveRecord::Migration
  def up
    add_column :accounts, :token_access, :string
  end

  def down
    remove_column :accounts, :token_access
  end
end
