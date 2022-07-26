class ChangeColumnOfUsers < ActiveRecord::Migration[5.2]
  def change
    change_column :users, :user_type, :integer
  end
end
