class AddLangToBookmarks < ActiveRecord::Migration[6.0]
  def change
    add_column :bookmarks, :lang, :integer, null: false, default: 0
  end
end
