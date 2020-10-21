class AddCreatorIdToRssSources < ActiveRecord::Migration[6.0]
  def change
    add_column :rss_sources, :creator_id, :bigint, null: false, default: 100, index: true
  end
end
