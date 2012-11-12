class UpdateSmsName < ActiveRecord::Migration
  def self.up
    add_column :sms, :name, :string
  end
  
  def self.down
    remove_column :sms, :name
  end
end
