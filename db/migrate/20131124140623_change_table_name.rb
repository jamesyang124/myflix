class ChangeTableName < ActiveRecord::Migration
  def change
    remove_index :comments, [:user_id, :video_id]
    rename_table :comments, :reviews
    add_index :reviews, [:user_id, :video_id]
  end
end
