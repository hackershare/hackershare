require_relative '20200917131007_add_code_to_rss_sources'

class ChangeRssSources < ActiveRecord::Migration[6.0]
  def change
    revert AddCodeToRssSources
    rename_column :rss_sources, :name, :tag_name
    add_column :rss_sources, :processed_at, :datetime
    add_column :rss_sources, :is_display, :boolean, null: false, default: false
  end
end
