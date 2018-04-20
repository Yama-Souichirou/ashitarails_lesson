class CreateTasks < ActiveRecord::Migration[5.0]
  def change
    create_table :tasks do |t|
      t.string  :title
      t.text    :description
      t.date    :deadline_on
      t.integer :status
      t.integer :priority
      t.integer :user_id

      t.timestamps
    end
  end
end
