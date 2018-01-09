ROM::SQL.migration do
  change do
    create_table :loyalty_cards do
      primary_key :id
      column :user_id, Integer, null: false
      column :discount, Integer
    end
  end
end
