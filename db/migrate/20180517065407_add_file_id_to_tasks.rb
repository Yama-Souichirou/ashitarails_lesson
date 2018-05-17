class AddFileIdToTasks < ActiveRecord::Migration[5.0]
  def change
    add_column :tasks, :file_id, :string
  end
end
