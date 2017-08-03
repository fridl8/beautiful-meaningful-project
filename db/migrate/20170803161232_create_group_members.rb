class CreateGroupMembers < ActiveRecord::Migration[5.1]
  def change
    create_table :group_members do |t|
      t.integer :user_id, null: false
      t.integer :group_id, null: false
    end
  end
end
