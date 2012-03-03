class CreateArtistRelations < ActiveRecord::Migration
  def change
    create_table :artist_relations do |t|
      t.string :user_id, :null=>false
      t.string :artist_hash_id,:null=>false
      t.integer :popularity 
      t.string :image_link

      t.timestamps
    end
  end
end
