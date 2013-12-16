class CreateRelationships < ActiveRecord::Migration
  def change
    create_table :relationships do |t|
      t.integer :leader_id, :follwer_id
      t.timestamps
    end
  end
end
