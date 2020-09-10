class AddCounterCacheForTagAndUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :follow_tags_count, :integer, default: 0
    add_column :tags, :subscriptions_count, :integer, default: 0
  end
end
