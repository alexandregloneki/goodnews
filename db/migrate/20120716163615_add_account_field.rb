class AddAccountField < ActiveRecord::Migration
  def up
    add_column :accounts, :city, :string
    add_column :accounts, :state, :string
    add_column :accounts, :neighbord, :string
    add_column :accounts, :street, :string
    add_column :accounts, :number_street, :string
    add_column :accounts, :phone, :string
    add_column :accounts, :postal_code, :string
    add_column :accounts, :country, :string
    add_column :accounts, :ddd, :string
    add_column :accounts, :name, :string
    add_column :accounts, :second_name, :string
    add_column :accounts, :user_document, :string
    remove_column :accounts, :customer_id
    add_column :accounts, :user_id, :integer
  end
  
  def down
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
    remove_column :accounts, :user_id
  end
end
