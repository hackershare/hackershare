class RemoveProcessedAtInRssSources < ActiveRecord::Migration[6.0]
  def change
    remove_column :rss_sources, :processed_at, :datetime
  end
end
