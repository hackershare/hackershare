class CreateComments < ActiveRecord::Migration[6.0]
  def change
    create_table :comments do |t|
      t.text :comment
      t.belongs_to :user, index: true
      t.belongs_to :bookmark, index: true
      t.timestamps
    end

    add_column :bookmarks, :comments_count, :integer, default: 0
    add_column :users, :comments_count, :integer, default: 0
  end
end
