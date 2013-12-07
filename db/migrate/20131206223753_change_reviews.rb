class ChangeReviews < ActiveRecord::Migration
  def change
    change_table :reviews do |t|  
      t.change :rating, :integer
    end
  end
end
