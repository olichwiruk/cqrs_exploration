class CreateOrderProcesses < ActiveRecord::Migration[5.1]
  def change
    create_table :order_processes do |t|
      t.string :uid
      t.boolean :completed
      t.string :order_id
      t.string :state
    end
  end
end
