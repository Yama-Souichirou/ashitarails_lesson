class CreateTaskImages < ActiveRecord::Migration[5.0]
  def change
    create_table :task_images do |t|
      t.string :file_id
      t.references :task, index: true

      t.timestamps
    end
  end
end
