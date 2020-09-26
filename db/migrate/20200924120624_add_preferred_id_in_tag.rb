class AddPreferredIdInTag < ActiveRecord::Migration[6.0]
  def change
    add_column :tags, :preferred_id, :bigint, index: true
  end
end
