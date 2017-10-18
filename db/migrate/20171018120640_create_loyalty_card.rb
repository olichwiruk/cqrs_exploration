class CreateLoyaltyCard < ActiveRecord::Migration[5.1]
  def change
    create_table :loyalty_cards do |t|
      t.integer :user_id
      t.integer :discount
    end
  end
end
