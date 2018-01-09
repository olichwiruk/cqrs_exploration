ROM::SQL.migration do
  change do
    create_table :orders do
      primary_key :id
      column :uuid, String, null: false
      column :user_id, Integer, null: false
      column :completed, FalseClass, default: false, null: false
    end
  end
end
