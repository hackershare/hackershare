class AddImagesForBookmarks < ActiveRecord::Migration[6.0]
  def change
    add_column :bookmarks, :images, :string, array: true, default: []
  end
end
