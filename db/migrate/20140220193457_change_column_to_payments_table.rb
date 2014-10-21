class ChangeColumnToPaymentsTable < ActiveRecord::Migration
  def change
    remove_column :payments, :create_at, :string
    remove_column :payments, :start_date, :string
    remove_column :payments, :end_date, :string

    add_column :payments, :create_at, :integer
    add_column :payments, :start_date, :integer
    add_column :payments, :end_date, :integer
  end
end
