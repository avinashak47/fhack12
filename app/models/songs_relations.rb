class SongsRelations < ActiveRecord::Base
      validates :user_id , :presence=>true, :uniqueness => true 
      validates :song_hash_id , :presence=>true
      		:popularity
      validates :last_listened, :presence=>true
      		:friends_who_played
      		:image_link

end
