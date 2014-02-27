class AddCustomerTokenToPayments < ActiveRecord::Migration
  def change
    add_column :payments, :create_at, :string
    add_column :payments, :start_date, :string
    add_column :payments, :end_date, :string
  end
end
