class ChangeIsDisplayDefaultInRssSources < ActiveRecord::Migration[6.0]
  def change
    change_column_default :rss_sources, :is_display, form: false, to: true
  end
end
