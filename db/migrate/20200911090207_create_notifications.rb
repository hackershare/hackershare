class CreateNotifications < ActiveRecord::Migration[6.0]
  def change
    create_table :notifications do |t|
      t.references :recipient, polymorphic: true, null: false
      t.string :type, null: false
      t.jsonb :params
      t.datetime :read_at

      t.timestamps
    end
  end
end
