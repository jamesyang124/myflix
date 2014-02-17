class CreatePaymentTable < ActiveRecord::Migration
  def change
    create_table :payment do |t|
      t.integer :user_id
      t.integer :amount
      t.string :reference_id
    end
  end
end
