class ChangeColumnTypeToIntegerInUserTable < ActiveRecord::Migration[5.2]
  def change
    change_column :bugs, :bug_type, :integer,  default: 0, using: 'bug_type::integer'
    change_column :bugs, :bug_status, :integer, default: 0, using: 'bug_status::integer'
    #Ex:- change_column("admin_users", "email", :string, :limit =>25)
  end
end
