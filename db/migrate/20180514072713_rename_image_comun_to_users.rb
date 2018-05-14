class RenameImageComunToUsers < ActiveRecord::Migration[5.0]
  def change
    rename_column :users, :image, :image_id
  end
end
