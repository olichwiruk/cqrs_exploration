class CreateWriteRepo < ActiveRecord::Migration[5.1]
  def change
    create_table :write_repo do |t|
      t.string :aggregate_type
      t.string :aggregate_uuid
      t.string :event_name
      t.string :data

      t.datetime :created_at
    end
  end
end
