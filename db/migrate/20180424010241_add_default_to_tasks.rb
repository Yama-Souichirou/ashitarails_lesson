class AddDefaultToTasks < ActiveRecord::Migration[5.0]
  def up
    change_column_default :tasks, :status, 1
    change_column_default :tasks, :priority, 1
  end
  
  def down
    change_column_default :tasks, :status, nil
    change_column_default :tasks, :priority, nil
  end
end
