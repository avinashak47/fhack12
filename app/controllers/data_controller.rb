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
	frndsLimit = (friends.length / 50).ceil;

		while (frndsLimit>0) do
			friendArtistData[frndsLimit-1] = Array.new
			friendMusicData[frndsLimit-1] = Array.new
			
			friendArtistData[frndsLimit-1], friendMusicData[frndsLimit-1] = graph.batch do |batch_api|
				friends[((frndsLimit-1)*25)..(frndsLimit*25-1)].each { |friend|
			 		batch_api.get_connections("#{friend['id']}", "music")
					  batch_api.get_connections("#{friend['id']}", 'music.listens')
				}
			end
			
			frndsLimit-=1
		end


		return [friendArtistData]
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
