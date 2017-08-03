class CreateGroups < ActiveRecord::Migration[5.1]
  def change
    create_table :groups do |t|
      t.string :name, null: false
      t.integer :creator_id, null: false
      t.string :description
      t.timestamps
    end
  end
end
