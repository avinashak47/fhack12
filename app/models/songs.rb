class Songs < ActiveRecord::Base
	validates :hash_id, :presence=>true, :uniqueness => true 
	validates :song_name, :presence=>true
		  :album_name
	validates :artist_name, :presence=>true
end
