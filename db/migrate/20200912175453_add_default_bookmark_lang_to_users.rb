class AddDefaultBookmarkLangToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :default_bookmark_lang, :integer, null: false, default: 0
  end
end
