class AddFieldAccount < ActiveRecord::Migration
  def up
    remove_column :accounts, :city
    remove_column :accounts, :state
    remove_column :accounts, :neighbord
    remove_column :accounts, :street
    remove_column :accounts, :number_street
    remove_column :accounts, :phone
    remove_column :accounts, :postal_code
    remove_column :accounts, :country
    remove_column :accounts, :ddd
    remove_column :accounts, :name
    remove_column :accounts, :second_name
    remove_column :accounts, :user_document
    add_column :users, :city, :string
    add_column :users, :state, :string
    add_column :users, :neighbord, :string
    add_column :users, :street, :string
    add_column :users, :number_street, :string
    add_column :users, :phone, :string
    add_column :users, :postal_code, :string
    add_column :users, :country, :string
    add_column :users, :ddd, :string
    add_column :users, :name, :string
    add_column :users, :second_name, :string
    add_column :users, :user_document, :string 
  end

  def down
  end
end
