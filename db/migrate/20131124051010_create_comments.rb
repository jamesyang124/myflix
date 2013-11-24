class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.decimal :rating, precision: 3, scale: 2
      t.text :opinion
      t.integer :user_id
      t.integer :video_id

      t.timestamps
    end

    add_index :comments, [:user_id, :video_id]
  end
end
