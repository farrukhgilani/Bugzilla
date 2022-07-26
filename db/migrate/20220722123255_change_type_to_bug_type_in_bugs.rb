class ChangeTypeToBugTypeInBugs < ActiveRecord::Migration[5.2]
  def change
    rename_column :bugs, :type, :bug_type
    rename_column :bugs, :status, :bug_status
    #Ex:- change_column("admin_users", "email", :string, :limit =>25)
  end
end
