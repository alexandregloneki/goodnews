class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.string :name
      t.references :status
      t.string :imagem
      t.string :codigo_integracao

      t.timestamps
    end
    add_index :payments, :status_id
  end
end
