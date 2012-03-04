class DataController < ApplicationController


def build_song_index
	begin

	graph = Koala::Facebook::API.new(session[:oauth_token])
	friends = graph.get_connections("me", "friends")	
	profile = graph.get_object("me")	
	friends << {'id'=>profile['id'],'name'=>profile['name']}
	friendArtistData = Array.new
	friendMusicData = Array.new
	frndsLimit = (friends.length / 25).ceil;
	userID=profile['id']

	userSeen = SeenUsers.where(:user_id=>userID)

	if (userSeen[0]!="null"  && userSeen.to_json!="[]" )
		render :json => {:status=>"user seen"}		
		return
	else
		userSeen = SeenUsers.new(:user_id=>userID)
		userSeen.save
	end

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
									datahash={:artist_hash_id=>artistData['id'],:user_id=>userID, :popularity=>1}
								checkExisting = Artists.where(:hash_id=>artistData['id'])

								if (checkExisting[0]!="null"  && checkExisting.to_json!="[]" )
							
									checkUserHas = ArtistRelations.where(datahash)
									if (checkUserHas[0].to_json!="null")
										datahash= ActiveSupport::JSON.decode(checkUserHas[0].to_json)
										datahash['popularity']=Integer(datahash['popularity'])+ 1
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


		friendMusicData.each { |batch|
			if (!batch.nil?)
			batch.each { |musicDataArray| 
					if (!musicDataArray.nil?)
						musicDataArray.each { |musicData|
						if (!musicData.nil?)
							if (musicData.is_a?(Hash))
							datahash2={:song_hash_id=>musicData['data']['song']['id'],:user_id=>userID, :popularity=>1}
								checkExisting = Songs.where(:hash_id=>musicData['data']['song']['id'])
								if (checkExisting[0].to_json!="null" && checkExisting.to_json!="[]" )

									checkUserHas = SongsRelations.where(datahash2)
									if (checkUserHas[0].to_json!="null")
										datahash2= ActiveSupport::JSON.decode(checkUserHas[0].to_json)
										datahash2['popularity'] = Integer(datahash2['popularity'])+ 1
									end
										newSongRelation = SongsRelations.new(datahash2)
										newSongRelation.save
										
								else
									tempSong = Songs.new
									tempDetails = graph.get_object("#{musicData['data']['song']['id']}")
									tempSong[:hash_id] = musicData['data']['song']['id']	
									tempSong[:song_name] = musicData['data']['song']['title']
									if (!tempDetails.nil?)
										if (!tempDetails['data'].nil?)
											if (!tempDetails['data']['album'].nil?)
												tempSong[:album_name] = tempDetails['data']['album'][0]['url']['title']
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
	
	render :json=>{:result=>"setup success"}
	return 

	rescue Exception=>e
		render :json=>{:error=>e.msg}
		return
	end
end


def get_songs
	begin
		graph = Koala::Facebook::API.new(session[:oauth_token])
		profile = graph.get_object("me")	
		userID = profile['id'];
		
		userQuery = SongsRelations.where(:user_id=>userID)
		userQueryResult = ActiveSupport::JSON.decode(userQuery.to_json)
		
		returnArray=Array.new
		userQueryResult.each { |result| 
			dataElem=Hash.new
			dataElem[:plays] = result['popularity']
			songQuery = Songs.where(:hash_id=>result['song_hash_id'])
			songData = ActiveSupport::JSON.decode(songQuery.to_json)
			dataElem[:artist] =String( songData[0]['artist_name'] )
			dataElem[:album] = String (songData[0]['album_name'])
			dataElem[:title] = songData['0']['song_name']
			returnArray << dataElem
		}

		render :json => {:data=>returnArray}
		return

	end	

end

end
