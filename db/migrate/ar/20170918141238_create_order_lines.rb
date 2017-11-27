# frozen_string_literal: true

class CreateOrderLines < ActiveRecord::Migration[5.1]
  def change
    create_table :order_lines do |t|
      t.integer :order_id
      t.integer :product_id
      t.integer :quantity
    end

    add_index(:order_lines, %i[order_id product_id])
  end
end
