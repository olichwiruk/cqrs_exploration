ROM::SQL.migration do
  change do
    create_table :write_repo do
      primary_key :id
      column :aggregate_type, String, null: false
      column :aggregate_uuid, String, null: false
      column :event_name, String, null: false
      column :data, String
      column :created_at, String, null: false
    end
  end
end
