# frozen_string_literal: true

# migration
class InsertColumnDevIdToBugs < ActiveRecord::Migration[5.2]
  def change
    add_column :bugs, :dev_id, :integer
  end
end
