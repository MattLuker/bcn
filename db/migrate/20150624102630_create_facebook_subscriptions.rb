class CreateFacebookSubscriptions < ActiveRecord::Migration
  def change
    create_table :facebook_subscriptions do |t|
      t.string :verify_token
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
