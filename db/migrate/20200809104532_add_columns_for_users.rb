class AddColumnsForUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :about, :text
    add_column :users, :homepage, :string
  end
end
