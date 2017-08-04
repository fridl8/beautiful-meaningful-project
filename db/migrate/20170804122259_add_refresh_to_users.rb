class AddRefreshToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :refresh, :string
  end
end
