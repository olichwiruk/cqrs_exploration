ROM::SQL.migration do
  change do
    create_table :order_process_managers do
      primary_key :id
      column :order_uuid, String, null: false
      column :completed, String, null: false
      column :state, String, null: false
    end
  end
end
