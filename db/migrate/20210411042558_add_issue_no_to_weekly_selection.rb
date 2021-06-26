class AddIssueNoToWeeklySelection < ActiveRecord::Migration[6.0]
  def change
    add_column :weekly_selections, :issue_no, :bigint
    reversible do |dir|
      dir.up do
        WeeklySelection.update_all("issue_no = id")
      end
    end
  end
end
