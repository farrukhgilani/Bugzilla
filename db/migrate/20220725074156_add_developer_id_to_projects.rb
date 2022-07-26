class AddDeveloperIdToProjects < ActiveRecord::Migration[5.2]
  def change
    add_column :projects, :dev_id, :integer, array: true, default: []
  end
end
