class CreateBasket < ActiveRecord::Migration[5.1]
  def change
    create_table 'r.baskets' do |t|
      t.integer :user_id
      t.string :products
      t.integer :discount
      t.float :total_price
      t.float :final_price
    end
  end
end
