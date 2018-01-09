ROM::SQL.migration do
  change do
    create_table :baskets do
      primary_key :id
      column :user_id, Integer, null: false
#      column :products, String
      column :discount, Integer
      column :total_price, Float
      column :final_price, Float
    end
  end
end
