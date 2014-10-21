class RemoveTimestampAtPaymentsTable < ActiveRecord::Migration
  def change
    remove_column :payments, :timestamp, :integer
  end
end
