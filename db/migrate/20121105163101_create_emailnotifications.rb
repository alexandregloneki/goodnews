class CreateEmailnotifications < ActiveRecord::Migration
  def change
    create_table :emailnotifications do |t|
      t.references :email

      t.timestamps
    end
    add_index :emailnotifications, :email_id
  end
end
