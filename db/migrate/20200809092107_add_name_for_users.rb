class AddNameForUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :username, :string, index: {unique: true}
  end
end
