class CreateOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :orders do |t|
      t.string :uuid
      t.string :user_id
      t.integer :discount, default: 0

      t.timestamps
    end
  end
end
