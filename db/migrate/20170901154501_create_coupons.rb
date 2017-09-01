class CreateCoupons < ActiveRecord::Migration[5.1]
  def change
    create_table :coupons do |t|
      t.string :uid
      t.integer :value
      t.string :state

      t.timestamps
    end
  end
end
