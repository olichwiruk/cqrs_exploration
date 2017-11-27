ROM::SQL.migration do
  change do
    create_table :users do
      primary_key :id
      column :uuid, String, null: false
      column :name, String, null: false
      column :email, String, null: false
    end
  end
end
