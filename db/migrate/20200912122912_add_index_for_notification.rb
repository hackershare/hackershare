class AddIndexForNotification < ActiveRecord::Migration[6.0]
  def change
    add_index :notifications, [:recipient_type, :recipient_id, :read_at, :created_at], order: {
      recipient_type: :desc,
      recipient_id: :desc,
      read_at: :desc,
      created_at: :desc
    }, name: "notifications_idx_0"

    add_index :notifications, :params
  end
end
