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
	userID=profile['id']
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
		
		datahash=Hash.new
	
		friendArtistData.each { |batch|
			if (!batch.nil?)
			batch.each { |artistDataArray|
				if (!artistDataArray.nil?)
					artistDataArray.each { |artistData|
					if (!artistData.nil?)
							if (artistData.is_a?(Hash))
								checkExisting = Artists.where(:hash_id=>artistData['id'])
									datahash={:artist_hash_id=>artistData['id'],:user_id=>userID, :popularity=>1}
								if (!checkExisting.nil?)
							
									checkUserHas = ArtistRelations.where(datahash)
									if (checkUserHas[0].to_json!="null")
										datahash= checkUserHas[0].to_json
										return checkUserHas[0].to_json
										datahash['popularity']+=1
									end
										newArtistRelation = ArtistRelations.new(datahash)
										newArtistRelation.save
											
								else
									tempArtist = Artists.new
									tempArtist[:hash_id] = artistData['id']
									tempArtist[:group_name] = artistData['name']
									if (tempArtist.valid?)
											tempArtist.save
											newArtistRelation = ArtistRelations.new(datahash)
											newArtistRelation.save
									end	
								end
						end
					end	
					}	
				end				
			}
			end
		}
		datahash2=Hash.new		
		datahash2={:song_hash_id=>musicData['data']['song']['id'],:user_id=>userID, :popularity=>1}

		friendMusicData.each { |batch|
			if (!batch.nil?)
			batch.each { |musicDataArray| 
					if (!musicDataArray.nil?)
						musicDataArray.each { |musicData|
						if (!musicData.nil?)
							if (musicData.is_a?(Hash))
								checkExisting = Songs.where(:hash_id=>musicData['data']['song']['id'])
								if (!checkExisting.nil?)

									checkUserHas = SongsRelations.where(datahash2)
									if (checkUserHas[0].to_json!="null")
										datahash2= checkUserHas[0].to_json
										datahash2['popularity']+=1
									end
										newSongRelation = SongsRelations.new(datahash2)
										newSongRelation.save
										
								else
									tempSong = Songs.new
									#return musicData
									tempDetails = graph.get_object("#{musicData['data']['song']['id']}")
									tempSong[:hash_id] = musicData['data']['song']['id']	
									tempSong[:song_name] = musicData['data']['song']['title']
									#return tempDetails
									if (!tempDetails.nil?)
										if (!tempDetails['data'].nil?)
											if (!tempDetails['data']['album'].nil?)
												tempSong[:albumName] = tempDetails['data']['album'][0]['url']['title']
											end
											if (!tempDetails['data']['musician'].nil?)
												tempSong[:artist_name] = tempDetails['data']['musician'][0]['name']
											end
										end
									end
									if (tempSong.valid?)
										tempSong.save
										newSongRelation = SongsRelations.new(datahash2)
										newSongRelation.save
									end
								end
							end
						end
					}					
					end
					}
			end
		}
	
	
	return 
end


end
