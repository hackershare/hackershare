class CreateClicks < ActiveRecord::Migration[6.0]
  def change
    create_table :clicks do |t|
      t.belongs_to :bookmark, index: true
      t.belongs_to :user
      t.index [:user_id, :bookmark_id]
      t.timestamps
    end
  end
end
