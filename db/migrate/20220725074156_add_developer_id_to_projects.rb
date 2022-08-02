# frozen_string_literal: true

# migration
class AddDeveloperIdToProjects < ActiveRecord::Migration[5.2]
  def change
    add_column :projects, :dev_id, :integer
  end
end
