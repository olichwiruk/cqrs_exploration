class CreateOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :orders do |t|
      t.string :uid
      t.string :user_uid
      t.integer :discount, default: 0

      t.timestamps
    end
  end
end
