class ChangeReviewsColumn < ActiveRecord::Migration
  def change
    rename_column :reviews, :opinion, :content
  end
end
