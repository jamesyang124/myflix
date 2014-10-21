class ChangeRelationships < ActiveRecord::Migration
  def change
    rename_column :relationships, :follwer_id, :follower_id
  end
end
