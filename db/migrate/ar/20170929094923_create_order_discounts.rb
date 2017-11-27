class CreateOrderDiscounts < ActiveRecord::Migration[5.1]
  def change
    create_table :order_discounts do |t|
      t.integer :order_id
      t.integer :discount_id
    end
  end
end
