ROM::SQL.migration do
  change do
    create_table :products do
      primary_key :id
      column :uuid, String, null: false
      column :name, String, null: false
      column :quantity, Integer, null: false
      column :price, Integer, null: false
    end
  end
end
