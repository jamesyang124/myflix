class RenamePayments < ActiveRecord::Migration
  def change
    rename_table :payment, :payments
  end
end
