class AddTimestampToPaymentsTable < ActiveRecord::Migration
  def change
    add_column :payments, :timestamp, :integer
  end
end
