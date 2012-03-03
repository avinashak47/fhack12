class CreateSongsRelations < ActiveRecord::Migration
  def change
    create_table :songs_relations do |t|
      t.string :user_id , :null=>false
      t.string :song_hash_id , :null=>false
      t.integer :popularity
      t.date :last_listened
      t.string :friends_who_played
      t.string :image_link

      t.timestamps
    end
  end
end
