class AddLimitToRssSources < ActiveRecord::Migration[6.0]
  def change
    add_column :rss_sources, :limit, :integer
  end
end
