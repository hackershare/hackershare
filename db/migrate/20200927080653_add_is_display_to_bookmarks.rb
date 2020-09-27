class AddIsDisplayToBookmarks < ActiveRecord::Migration[6.0]
  def change
    add_column :bookmarks, :is_display, :boolean, null: false, default: true
  end
end
