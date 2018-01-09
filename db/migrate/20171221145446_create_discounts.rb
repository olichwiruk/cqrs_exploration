ROM::SQL.migration do
  change do
    create_table :discounts do
      primary_key :id
      column :name, String, null: false
      column :value, Integer
    end
  end
end
