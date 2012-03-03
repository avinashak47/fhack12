class CreateSeenUsers < ActiveRecord::Migration
  def change
    create_table :seen_users do |t|
      t.string :user_id

      t.timestamps
    end
  end
end
