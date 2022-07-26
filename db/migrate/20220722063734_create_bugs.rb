class CreateBugs < ActiveRecord::Migration[5.2]
  def change
    create_table :bugs do |t|
      t.string :title
      t.date :deadline
      t.string :type
      t.string :status
      t.integer :project_id

      t.timestamps
    end
  end
end
