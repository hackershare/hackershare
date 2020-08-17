class AddFaviconAndDesc < ActiveRecord::Migration[6.0]
  def change
    add_column :bookmarks, :favicon, :string
    add_column :bookmarks, :description, :text
    add_column :bookmarks, :dups_count, :integer, default: 0
  end
end
