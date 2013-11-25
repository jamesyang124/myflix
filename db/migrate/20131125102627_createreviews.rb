class Createreviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.decimal :rating, precision: 3, scale: 2
      t.text :opinion
      t.integer :user_id
      t.integer :video_id

      t.timestamps
    end

    add_index :reviews, [:user_id, :video_id]
  end
end
