class CreateBasket < ActiveRecord::Migration[5.1]
  def change
    create_table 'r.baskets' do |t|
      t.integer :order_id
      t.string :products
      t.integer :discount
      t.integer :total_price
    end
  end
end
