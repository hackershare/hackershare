class FixDup < ActiveRecord::Migration[6.0]
  def change
    add_index :bookmarks, %i[url user_id], unique: true
  end
end
