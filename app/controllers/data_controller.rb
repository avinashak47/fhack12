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
	profile = graph.get_object("me")	
	friends << {'id'=>profile['id'],'name'=>profile['name']}
	friendArtistData = Array.new
	friendMusicData = Array.new
	friends.each { |friend|
		frndArtist = graph.get_connections(friend['id'], "music")
		if (!frndArtist.nil?)
			friendArtistData << frndArtist
		end
		frndMusic = graph.get_connections(friend['id'], "music.listens")	
		if (!frndMusic.nil?)				
			friendMusicData << frndMusic
		end			
	}	

		return [friendMusicData.length, friendArtistData.length]
		friendArtistData.each { |artistData| 		
			tempArtist = Artists.new
			tempArtist[:hash_id] = String(artistData['id'])	
			tempArist[:group_name] = artistData['name']
			if (tempArtist.valid?)
					tempArtist.save
			end						
		}

		friendMusicData.each { |musicData| 
			tempSong = Songs.new
			tempDetails = graph.get_object("#{musicData['data']['id']}")
			tempSong[:hash_id] = musicData['data']['id']	
			tempSong[:song_name] = musicData['song']['title']
			tempSong[:albumName] = tempDetails['data']['album']['url']['title']
			tempSong[:artist_name] = tempDetails['data']['musicians']['name']
			if (tempSong.valid?)
				tempSong.save
			end
																																																																																																																				
		}
	
	
	return 
end


end
