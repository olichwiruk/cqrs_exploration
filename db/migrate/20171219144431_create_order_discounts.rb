ROM::SQL.migration do
  change do
    create_table :order_discounts do
      primary_key :id
      column :order_id, Integer, null: false
      column :discount_id, Integer, null: false
    end
  end
end
