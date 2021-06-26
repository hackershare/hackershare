class AddIndexForTagSubscriptionsCount < ActiveRecord::Migration[6.0]
  def change
    add_index :tags, :subscriptions_count, order: {subscriptions_count: :desc}
  end
end
