class AddPinCommentId < ActiveRecord::Migration[6.0]
  def change
    add_column :bookmarks, :pinned_comment_id, :bigint
  end
end
