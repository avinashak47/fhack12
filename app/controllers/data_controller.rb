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
	frndsLimit = (friends.length / 25).ceil;
	counter=0
		while (counter<=frndsLimit) do
			friendArtistData[counter] = Array.new
			friendMusicData[counter] = Array.new
			
			friendArtistData[counter]= graph.batch do |batch_api| 	
				friends[(counter*25)..((counter+1)*25-1)].each { |friend|
				 		batch_api.get_connections("#{friend['id']}", 'music')
				}
			end

			friendMusicData[counter] = graph.batch do |batch_api| 	
				friends[(counter*25)..((counter+1)*25-1)].each { |friend|
					  batch_api.get_connections("#{friend['id']}", 'music.listens')
				}
			end
			
			counter+=1
		end


		return {:artists=>friendArtistData,:songs=>friendMusicData}
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
