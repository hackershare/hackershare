class AddColumnsForTags < ActiveRecord::Migration[6.0]
  def change
    add_column :tags, :description, :text
    add_column :tags, :remote_img_url, :string
  end
end
