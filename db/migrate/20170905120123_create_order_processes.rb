class CreateOrderProcesses < ActiveRecord::Migration[5.1]
  def change
    create_table :order_processes do |t|
      t.string :order_id, null: false
      t.boolean :completed
      t.string :state
    end

    add_index :order_processes, :order_id, unique: true
  end
end
