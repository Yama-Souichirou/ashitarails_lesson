class AddResponsibleToTasks < ActiveRecord::Migration[5.0]
  def change
    add_column :tasks, :responsible_id, :integer
    add_index :tasks, :responsible_id
  end
end
