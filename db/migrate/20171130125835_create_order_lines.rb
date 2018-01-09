ROM::SQL.migration do
  change do
    create_table :order_lines do
      primary_key :id
      column :order_id, Integer, null: false
      column :product_id, Integer, null: false
      column :quantity, Integer, null: false
    end
  end
end
