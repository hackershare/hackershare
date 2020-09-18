class AddIsRssForTags < ActiveRecord::Migration[6.0]
  def change
    add_column :tags, :is_rss, :boolean, default: false
    add_column :rss_sources, :tag_id, :bigint, index: true
  end
end
