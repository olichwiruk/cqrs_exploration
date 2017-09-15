class CreateProducts < ActiveRecord::Migration[5.1]
  def change
    create_table :products do |t|
      t.string :uuid
      t.string :name
      t.integer :quantity
      t.integer :price
    end
  end
end
