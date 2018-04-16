class CreateTasks < ActiveRecord::Migration[5.0]
  def change
    create_table :tasks do |t|
      t.string  :title
      t.text    :description
      t.date    :dead
      t.integer :priority

      t.timestamps
    end
  end
end
