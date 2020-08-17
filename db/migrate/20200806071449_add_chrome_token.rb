class AddChromeToken < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :extension_token, :string, index: { unique: true }
  end
end
