class AddEmailNotifySetting < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :enable_email_notification, :boolean, default: true
  end
end
