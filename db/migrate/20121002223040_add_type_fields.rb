class AddTypeFields < ActiveRecord::Migration
  def change
    create_table :type_fields do |t|
      t.string :name
      t.string :key
      t.timestamps
    end
    
  end

end
