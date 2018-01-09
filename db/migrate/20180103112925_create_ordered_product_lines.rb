ROM::SQL.migration do
  change do
    create_table :ordered_product_lines do
      primary_key :order_line_id
      column :basket_id, Integer, null: false
      column :product_id, Integer, null: false
      column :added_quantity, Integer, null: false
    end
  end
end
