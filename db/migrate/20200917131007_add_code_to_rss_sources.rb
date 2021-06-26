class AddCodeToRssSources < ActiveRecord::Migration[6.0]
  def change
    add_column :rss_sources, :code, :string, null: false, default: ""
  end
end
