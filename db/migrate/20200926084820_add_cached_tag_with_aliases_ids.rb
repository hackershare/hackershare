class AddCachedTagWithAliasesIds < ActiveRecord::Migration[6.0]
  def change
    add_column :bookmarks, :cached_tag_with_aliases_names, :string, array: true, default: []
    add_column :bookmarks, :cached_tag_with_aliases_ids, :bigint, array: true, default: []
  end
end
