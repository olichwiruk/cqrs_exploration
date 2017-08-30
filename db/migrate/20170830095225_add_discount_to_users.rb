# frozen_string_literal: true

class AddDiscountToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :discount, :integer
    change_column_default :users, :discount, 0
  end
end
