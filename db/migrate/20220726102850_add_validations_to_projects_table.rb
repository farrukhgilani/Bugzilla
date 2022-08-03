# frozen_string_literal: true

# migration
class AddValidationsToProjectsTable < ActiveRecord::Migration[5.2]
  def change
    change_column :projects, :name, :string, null: false
    change_column :projects, :description, :text, null: false

    change_column :bugs, :title, :string, null: false
    change_column :bugs, :bug_type, :integer, null: false
    change_column :bugs, :bug_status, :integer, null: false
    change_column :bugs, :project_id, :integer, null: false
  end
end
