class ArtistRelations < ActiveRecord::Base
      validates :user_id , :presence=>true
      validates :artist_hash_id , :presence=>true
      		:popularity
      		:last_listened
      		:friends_who_played
      		:image_link

end
