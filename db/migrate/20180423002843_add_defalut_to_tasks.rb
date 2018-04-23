class AddDefalutToTasks < ActiveRecord::Migration[5.0]
  def change
    change_column :tasks, :title, :string, null: false
    change_column :tasks, :deadline_on, :date, null: false
    change_column :tasks, :status, :integer, null: false
    change_column :tasks, :priority, :integer, null: false
  end
end
