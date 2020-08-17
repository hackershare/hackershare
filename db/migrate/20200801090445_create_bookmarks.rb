class CreateBookmarks < ActiveRecord::Migration[6.0]
  def change
    create_table :bookmarks do |t|
      t.references :user, index: true
      t.string :url
      t.string :title
      t.bigint :ref_id, index: true
      t.timestamps
    end
  end
end
