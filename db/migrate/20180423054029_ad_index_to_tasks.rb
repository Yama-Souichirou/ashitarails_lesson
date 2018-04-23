class AdIndexToTasks < ActiveRecord::Migration[5.0]
  def change
    add_index :tasks, [:user_id, :deadline_on, :priority]
  end
end
