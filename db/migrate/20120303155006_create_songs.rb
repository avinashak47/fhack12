class CreateSongs < ActiveRecord::Migration
  def change
    create_table :songs do |t|
      t.string :hash_id, :null=>false
      t.string :song_name, :null=>false
      t.string :album_name
      t.string :artist_name, :null=>false

      t.timestamps
    end
  end
end
