class AddTsvFieldForSearch < ActiveRecord::Migration[6.0]
  def change
    add_column :bookmarks, :content, :text
    add_column :bookmarks, :cached_tag_names, :string
    add_column :bookmarks, :tsv, :tsvector
    add_column :bookmarks, :cached_tag_ids, :bigint, array: true, default: []
  end
end
