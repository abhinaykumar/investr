class CreateAuthorizations < ActiveRecord::Migration[5.2]
  def change
    create_table :authorizations do |t|
      t.string :provider
      t.string :uid
      t.string :token
      t.string :secret
      t.string :expires_at
      t.string :refresh_token
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
