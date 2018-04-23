class AddDefalutToTasks < ActiveRecord::Migration[5.0]
  def change
    change_column :tasks, :title, :string, null: false
    change_column :tasks, :deadline_on, :date, null: false
    change_column :tasks, :status, :date, null: false
    change_column :tasks, :priority, :date, null: false
  end
end
