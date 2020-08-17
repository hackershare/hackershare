class CreateFollows < ActiveRecord::Migration[6.0]
  def change
    create_table :follows do |t|
      t.bigint :user_id
      t.bigint :following_user_id
      t.timestamps
      t.index %i[user_id following_user_id], unique: true
    end
    add_column :users, :followers_count, :integer, default: 0
    add_column :users, :followings_count, :integer, default: 0
  end
end
