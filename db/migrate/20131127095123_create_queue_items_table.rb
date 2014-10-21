class CreateQueueItemsTable < ActiveRecord::Migration
  def change
    create_table :queue_items do |t|
      t.integer :video_id, :user_id
      t.integer :position

      t.timestamps
    end

    add_index :queue_items, [:video_id, :user_id]
  end
end
