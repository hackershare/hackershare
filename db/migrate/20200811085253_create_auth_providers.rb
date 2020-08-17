class CreateAuthProviders < ActiveRecord::Migration[6.0]
  def change
    create_table :auth_providers do |t|
      t.references :user, index: true
      t.jsonb :data
      t.string :provider
      t.string :uid
      t.timestamps
      t.index %i[provider uid], unique: true
    end
  end
end
