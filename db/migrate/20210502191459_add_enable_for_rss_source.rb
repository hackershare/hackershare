class AddEnableForRssSource < ActiveRecord::Migration[6.0]
  def change
    add_column :rss_sources, :enabled, :boolean, default: true
  end
end
