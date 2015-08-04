class CreateBadgesUsers < ActiveRecord::Migration
  def change
    create_table :badges_users do |t|
      t.belongs_to :badge, index: true
      t.belongs_to :user, index: true
    end
  end
end
