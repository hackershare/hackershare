class CreateTaggings < ActiveRecord::Migration[6.0]
  def change
    create_table :taggings do |t|
      t.belongs_to :tag
      t.belongs_to :bookmark
      t.timestamps
      t.index [:tag_id, :bookmark_id], unique: true
      t.belongs_to :user, index: true
    end
  end
end
