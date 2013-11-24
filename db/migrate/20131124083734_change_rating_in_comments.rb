class ChangeRatingInComments < ActiveRecord::Migration
  def change
    change_table :comments do |t|  
      t.change :rating, :decimal, { precision: 3, scale: 1 }
    end
  end
end
