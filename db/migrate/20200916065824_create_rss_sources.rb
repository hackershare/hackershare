class CreateRssSources < ActiveRecord::Migration[6.0]
  def change
    create_table :rss_sources do |t|
      t.string :name, null: false
      t.string :url, null: false
      t.datetime :processed_at

      t.timestamps
    end
  end
end
