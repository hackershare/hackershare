class AddAutoExtractForTag < ActiveRecord::Migration[6.0]
  def change
    add_column :tags, :auto_extract, :boolean, default: true
  end
end
