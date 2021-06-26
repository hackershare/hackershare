class FixUniqueEmail < ActiveRecord::Migration[6.0]
  def change
    add_index :users,
      "lower(email)",
      name: "index_users_on_email_lower_unique",
      unique: true
  end
end
