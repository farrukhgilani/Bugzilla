# frozen_string_literal: true

class RemoveDevIdFromProjectsTable < ActiveRecord::Migration[5.2]
  def change
    remove_column :projects, :dev_id
  end
end
