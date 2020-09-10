class CreateTagSubscriptions < ActiveRecord::Migration[6.0]
  def change
    create_table :tag_subscriptions do |t|
      t.belongs_to :user
      t.belongs_to :tag, index: true
      t.timestamps
      t.index [:user_id, :tag_id], unique: true
    end
  end
end
