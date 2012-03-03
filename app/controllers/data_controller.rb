class DataController < ApplicationController

def self.get_songs
	if (param[:id].nil?)
		render :json=> {}
		return
	end

end 

def self.build_song_index (oauth_access_token)
	graph = Koala::Facebook::API.new(oauth_access_token)
	friends = graph.get_connections("me", "friends")
	mymusic = graph.get_connections("me", "music")	
	profile = graph.get_object("me")	
	friends << {'id'=>profile['id'],'name'=>profile['name']}
	friendArtistData = Array.new
	friendMusicData = Array.new
	friends.each { |friend|
		friendArtistData << graph.get_connections("#{friend['id']}", "music")	
		friendMusicData <<  graph.get_connections("#{friend['id']}", "music.listens")	

		friendArtistData.each { |artistData| 
			tempArtist = Artist.new
			tempArtist[:hash_id] = artistData['id']
			tempArist[:group_name] = artistData['name']
			if (tempArtist.valid?)
				tempArtist.save
			end						
		}

		friendMusicData.each { |musicData| 
			tempSong = Song.new
			tempDetails = graph.get_object("#{musicData['data']['id']}")
			tempSong[:hash_id] = "#{musicData['data']['id']}"
			tempSong[:song_name] = musicData['song']['title']
			tempSong[:albumName] = tempDetails['data']['album']['url']['title']
			tempSong[:artist_name] = tempDetails['data']['musicians']['name']
			if (tempSong.valid?)
				tempSong.save
			end
																																																																																																																				
		}
	}
	
	return 
end


end
