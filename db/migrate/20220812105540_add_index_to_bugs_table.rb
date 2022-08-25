class AddIndexToBugsTable < ActiveRecord::Migration[5.2]
  def change
    add_index :bugs, :title, unique: true
    #Ex:- change_column("admin_users", "email", :string, :limit =>25)
  end
end
